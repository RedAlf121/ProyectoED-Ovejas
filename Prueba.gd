extends Node


onready var tile_map = $TileMap
onready var position_2d = $Position2D
onready var tile_map_2 = $TileMap2
onready var position_2_d_2 = $Position2D2


func _ready():
#	print("TileMap")
#	for i in tile_map.get_used_cells():
#		print(i)
#	print("Obstaculos")
#	for i in tile_map_2.get_used_cells():
#		print(i)
	var a = Graph.new()
	a.build_graph(tile_map,tile_map_2)
	var path = a.shortest_path(position_2d.position, position_2_d_2.position)
	var tween_time = 0.37
	for i in path:
		var direction = Vector2(sign(position_2d.position.x - i.get_global_position().x),sign(position_2d.position.y - i.get_global_position().y))
		direction = direction.normalized()
		match(direction):
			Vector2.LEFT:
				position_2d.rotation_degrees = 0
			Vector2.RIGHT:
				position_2d.rotation_degrees = 180
			Vector2.UP:
				position_2d.rotation_degrees = 90
			Vector2.DOWN:
				position_2d.rotation_degrees = 270
		var tween = get_tree().create_tween()
		tween.tween_property(position_2d,"position", i.get_global_position(), tween_time)
		
		yield(get_tree().create_timer(tween_time),"timeout")
	$Position2D2/Sprite.hide()
#for i in path:
#		print(i.get_global_position())
#		#position_2d.position = i.get_global_position()
#		var tween = get_tree().create_tween()
#		tween.tween_property(position_2d,"position", i.get_global_position(), tween_time)
#		yield(get_tree().create_timer(tween_time),"timeout")
