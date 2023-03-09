extends Node


onready var tile_map = $TileMap
onready var position_2d = $Position2D
onready var tile_map_2 = $TileMap2


func _ready():
	#for i in tile_map.get_used_cells():
	#	position_2d.position = i*tile_map.cell_size+tile_map.cell_size/2
	#	print(i)
	#for i in tile_map_2.get_used_cells():
	#	print(i)
	var a = Graph.new()
	a.build_graph(tile_map)

