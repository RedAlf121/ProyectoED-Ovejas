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
	var rectangle = Rect2(_position,size)
	#Buscar el punto medio
	#Ver si se incluye en el rectangulo
	#Si esta antes del rectangulo recorto por el li
	#Si esta despues del rectangulo recorto por el ls

func is_bussy():
	return _bussy
