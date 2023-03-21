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
 
func _linear_search(matrix,cell_size,rectangle,found):
	var bussy = false
	var i = found
	var j = found+1
	var current_rect_i = Rect2(matrix[i]*cell_size,cell_size)
	var found_rect = current_rect_i
	var current_rect_j = Rect2(matrix[j]*cell_size,cell_size) if(j < matrix.size()) else null
	while(!bussy and i >= 0 and j < matrix.size() and (current_rect_i.position.y == found_rect.position.y or current_rect_j.position.y == found_rect.position.y)):
		bussy = rectangle.intersects(current_rect_i) or rectangle.intersects(current_rect_j)
		if(current_rect_i.position.y == found_rect.position.y):
			i-=1
			current_rect_i = Rect2(matrix[i]*cell_size,cell_size)
		if(current_rect_j.position.y == found_rect.position.y):
			j+=1
			current_rect_j = Rect2(matrix[j]*cell_size,cell_size)
	return bussy

func _lower_bound(matrix: Array,cell_size: Vector2, comparing_low: bool) -> bool:
	#buscar rectangulo mas cercano por las y priorizando el mayor de los menores
	var bussy = false
	var li = 0
	var ls = matrix.size()-1
	var rectangle = Rect2(_position*size,size)
	var found = null
	while(li<=ls and !bussy):
		var mid = (li+ls)/2
		var middle_rect = Rect2(matrix[mid]*cell_size,cell_size)
		if(rectangle.intersects(middle_rect)):
			bussy = true
		if(comparing_low):
			if(middle_rect.position.y <= rectangle.position.y):
				found = mid
				li = mid+1
			else:
				ls = mid-1
		else:
			if(middle_rect.end.y <= rectangle.end.y):
				found = mid
				li = mid+1
			else:
				ls = mid-1
	if(!bussy and found != null):
		bussy = _linear_search(matrix,cell_size,rectangle,found)
	return bussy

func _upper_bound(matrix: Array,cell_size: Vector2, comparing_low: bool) -> bool:
	#buscar rectangulo mas cercano por las y priorizando el menor de los mayores
	var bussy = false
	var li = 0
	var ls = matrix.size()-1
	var rectangle = Rect2(_position*size,size)
	var found = null
	while(li<=ls and !bussy):
		var mid = (li+ls)/2
		var middle_rect = Rect2(matrix[mid]*cell_size,cell_size)
		if(rectangle.intersects(middle_rect)):
			bussy = true
		if(comparing_low):
			if(middle_rect.position.y >= rectangle.position.y):
				found = mid
				li = mid+1
			else:
				ls = mid-1
		else:
			if(middle_rect.end.y >= rectangle.end.y):
				found = mid
				li = mid+1
			else:
				ls = mid-1
	if(!bussy and found != null):
		bussy = _linear_search(matrix,cell_size,rectangle,found)
	return bussy

func _find_closest_rectangles(matrix: Array,size: Vector2) -> bool:
	var bussy = _lower_bound(matrix,size,false) or _lower_bound(matrix,size,true) or _upper_bound(matrix,size,false) or _upper_bound(matrix,size,true)
	return bussy

func is_bussy(obstacles: TileMap) -> bool:
	var matrix = obstacles.get_used_cells()
	var bussy = _find_closest_rectangles(matrix,obstacles.cell_size)
	return bussy

func get_adyacent_nodes():
	return _adyacent_nodes
