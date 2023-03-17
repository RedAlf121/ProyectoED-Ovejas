extends Node


onready var tile_map = $TileMap
onready var position_2d = $Position2D
onready var tile_map_2 = $TileMap2
onready var position_2_d_2 = $Position2D2


func _ready():
	#for i in tile_map.get_used_cells():
	#	print(i)
	#	position_2d.position = i*tile_map.cell_size+tile_map.cell_size/2
	#for i in tile_map_2.get_used_cells():
		#print(i*tile_map_2.cell_size)
	var a = Graph.new()
	a.build_graph(tile_map,tile_map_2)
	var path = a.shortest_path(position_2d.position, position_2_d_2.position)
	var tween_time = 0.37
	for i in path:
		print(i.get_global_position())
		#position_2d.position = i.get_global_position()
		var tween = get_tree().create_tween()
		tween.tween_property(position_2d,"position", i.get_global_position(), tween_time)
		yield(get_tree().create_timer(tween_time),"timeout")

#for i in path:
#		print(i.get_global_position())
#		#position_2d.position = i.get_global_position()
#		var tween = get_tree().create_tween()
#		tween.tween_property(position_2d,"position", i.get_global_position(), tween_time)
#		yield(get_tree().create_timer(tween_time),"timeout")
