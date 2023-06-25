extends Node2D

export(String, FILE) var main_menu
onready var item_list = $Control/ItemList
onready var text_edit = $Control/TextEdit
export (PackedScene) onready  var level_selector

func _ready():
	text_edit.grab_focus()

func find_saves(string):
	var save_list = LoadSave.trie.find_all_words(string)
	for i in save_list:
		item_list.add_item(i)


func _on_TextEdit_text_changed():
	item_list.clear()
	find_saves(text_edit.text)

func _load_pressed():
	LoadSave.actual_source = item_list.get_item_text(item_list.get_selected_items()[0])
	LoadSave.load_game()
	get_tree().change_scene_to(level_selector)


func _on_Erase_pressed():
	var string = item_list.get_item_text(item_list.get_selected_items()[0])
	LoadSave.delete_saves(string)
	text_edit.text = ""
	item_list.remove_item(item_list.get_selected_items()[0])
	text_edit.grab_focus()


func _on_Button_pressed():
	get_tree().change_scene(main_menu)
