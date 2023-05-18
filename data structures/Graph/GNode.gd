class_name GNode extends Node


var _adyacent_nodes : Array
var _position: Vector2
var size: Vector2 #variable estatica para el tamaño

func build(position: Vector2, new_size: Vector2) -> void:
	set_position(position)
	size = new_size

func add_node(node: GNode) -> void:
	_adyacent_nodes.append(node)

func set_position(position: Vector2) -> void:
	_position = position

func get_position() -> Vector2:
	return _position

func get_global_position() -> Vector2:
	return _position*size+size/2
 
func _linear_search(matrix,cell_size):
	var bussy = false
	var rectangle = Rect2(_position*size,size)
	var i = 0
	while(i < len(matrix) and !bussy):
		var current_rect_i = Rect2(matrix[i]*cell_size,cell_size)
		if(rectangle.intersects(current_rect_i)):
			bussy = true
		i+=1
	return bussy


func is_bussy(obstacles: TileMap) -> bool:
	var matrix = obstacles.get_used_cells()
	var bussy = _linear_search(matrix,obstacles.cell_size)
	return bussy

func get_adyacent_nodes():
	return _adyacent_nodes
