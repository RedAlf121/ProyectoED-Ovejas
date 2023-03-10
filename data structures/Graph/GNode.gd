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
 
func _close_obstacle(matrix):
	#busqueda binaria para buscar el mas cercano
	pass

func be_bussy(obstacles: TileMap):
	#Encontrar el obstaculo mas cercano
	var matrix = obstacles.get_used_cells()
	var position = _close_obstacle(matrix)
	#Crear un rectangulo con la posicion real del nodo
	#Ver si la posicion real del obstaculo se encuentra dentro del rectangulo del nodo
	#Hacer al atributo bussy true o false segun la condicion anterior
	pass

func is_bussy():
	return _bussy
