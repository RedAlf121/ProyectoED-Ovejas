class_name TestLevel extends Node2D

export(String, FILE) var level_selector

var list = []
var signal_dictionary = preload("res://singletons/SignalsDictionary.gd")
onready var item_list = $Canvas/ItemList
onready var item_list_2 = $Canvas/ItemList2
onready var audio_stream_player = $AudioStreamPlayer
onready var control_commands = $ControlCommands

func _ready():
	signal_dictionary = signal_dictionary.new()
	if(Singleton.mute == false):
		audio_stream_player.play()


func _on_Button_pressed():
	get_tree().change_scene(level_selector)

func _on_ItemList_item_selected(index):
	_add_to_second_list(index)


func _on_ItemList2_item_selected(index):
	item_list_2.remove_item(index)
	list.pop_at(index)

func _add_to_second_list(index):
	var signal_name = signal_dictionary.get_signal(index)
	if(signal_name != "-/"):
		list.push_back(signal_name)
		item_list_2.add_item(item_list.get_item_text(index),item_list.get_item_icon(index))




func start_commands():
	control_commands.start(list)
