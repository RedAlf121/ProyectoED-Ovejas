class_name TestLevel extends Node2D

export(String, FILE) var level_selector

signal finished

var list = []
var signal_dictionary = preload("res://singletons/SignalsDictionary.gd")
onready var item_list = $Canvas/ItemList
onready var item_list_2 = $Canvas/CommandShower
onready var audio_stream_player = $AudioStreamPlayer
onready var control_commands = $ControlCommands
#----------------------------------------------Zero------------------------------------------
onready var tile_map = $Floor
onready var tile_map_2 = $TileMap
onready var position_2_d_2 = $Destino
onready var a = Graph.new()
onready var Counter = 0
#--------------------------------------------------------------------------------------------
func _ready():
	signal_dictionary = signal_dictionary.new()
	if(Singleton.mute == false):
		audio_stream_player.play()
#---------------------------------------------Zero--------------------------------------------
	a.build_graph(tile_map,tile_map_2)

func _on_ItemList_item_selected(index):
	_add_to_second_list(index)



func _add_to_second_list(index):
	var signal_name = signal_dictionary.get_signal(index)
	if(signal_name != "-/"):
		list.push_back(signal_name)
		item_list_2.add_item(item_list.get_item_text(index),item_list.get_item_icon(index))




func start_commands():
	control_commands.start(list)



func _on_Atras_pressed():
	get_tree().change_scene(level_selector)
	pass # Replace with function body.


func _on_Reset_pressed():
	get_tree().change_scene("res://scenes/levels/levelorueba.tscn")
	pass # Replace with function body.


func _on_CommandShower_item_selected(index):
	item_list_2.remove_item(index)
	list.pop_at(index)



func _on_Sheep_run(sheep,final_position):
	if(sheep.stop):
		final_position = Vector2(int(final_position.x), int(final_position.y))
		var path = a.shortest_path(sheep.position, final_position)
		sheep.path = path
		sheep.timer.start()



func _on_ENDZONE_body_entered(body):
	Counter+=1
	if Counter == 3:
		get_tree().change_scene("res://scenes/levels/Felicidades.tscn")


