class_name TestLevel extends Node2D

export(String, FILE) var level_selector

signal finished

var list = []
var signal_dictionary = preload("res://singletons/SignalsDictionary.gd")
var stop = false
onready var item_list = $Canvas/ItemList
onready var item_list_2 = $Canvas/CommandShower
onready var audio_stream_player = $AudioStreamPlayer
onready var control_commands = $ControlCommands
#----------------------------------------------Zero------------------------------------------
onready var tile_map = $Floor
onready var tile_map_2 = $TileMap
onready var position_2_d_2 = $Destino
onready var a = Graph.new()
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
	standby_sheeps()
	control_commands.start(list)

func standby_sheeps():
	for i in get_children():
		if(i.is_in_group("sheep")):
			i.standby=true

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
	connect("finished",sheep,"restart_timer")
	#sheep.timer.stop()
	sheep.collision_shape_move_detector.disabled = true
	var path = a.shortest_path(sheep.position, final_position)
	var tween_time = 0.37
	yield(get_tree().create_timer(tween_time),"timeout")
	if(path!=null):
		var it = 0
		while(it < path.size() and !stop):
			var i = path[it]
			print(sheep.position)
			var direction = Vector2(sign(int(sheep.position.x - i.get_global_position().x)),sign(int(sheep.position.y - i.get_global_position().y)))
			direction = direction.normalized()
			match(direction):
				Vector2.LEFT:
					sheep.rotation_degrees = 0
				Vector2.RIGHT:
					sheep.rotation_degrees = 180
				Vector2.UP:
					sheep.rotation_degrees = 90
				Vector2.DOWN:
					sheep.rotation_degrees = 270
			var tween = get_tree().create_tween()
			tween.tween_property(sheep,"position", i.get_global_position(), tween_time)
			yield(get_tree().create_timer(tween_time),"timeout")
			it+=1
		emit_signal("finished",path==null)
		disconnect("finished",sheep,"restart_timer")
		stop = false


func _on_Sheep_stop_moving():
	stop = true
