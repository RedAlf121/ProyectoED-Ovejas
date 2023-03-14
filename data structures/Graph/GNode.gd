class_name GNode extends Node


var _adyacent_nodes : Array
var _position
var _bussy #para saber si hay un obstaculo en ese nodo
var size #variable estatica para el tamaño

func _init():
	_bussy = false

func build(position, new_size):
	set_position(position)
	size = new_size

func add_node(node):
	_adyacent_nodes.append(node)

func set_position(position):
	_position = position

func get_position():
	return _position

func get_global_position():
	return _position*size+size/2
 

func be_bussy(obstacles: TileMap):
	var matrix = obstacles.get_used_cells()
	var rectangle = Rect2(_position*size,size)
	var li = 0
	var ls = matrix.size()-1
	var mid
	var middle_rect
	while(li<=ls and !_bussy):
		mid = (li+ls)/2
		#Buscar el punto medio
		middle_rect = Rect2(matrix[mid]*obstacles.cell_size,obstacles.cell_size)
		#Ver si se incluye en el rectangulo
		if(rectangle.intersects(middle_rect)):
			_bussy = true
		#Si esta antes del rectangulo recorto por el li
		elif(middle_rect.position.y < rectangle.position.y or (middle_rect.position.y == rectangle.position.y and middle_rect.position.x < rectangle.position.x)):
			li = mid+1
		#Si esta despues del rectangulo recorto por el ls
		else:
			ls = mid-1

func is_bussy():
	return _bussy
