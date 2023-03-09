class_name GNode extends Node


var _adyacent_nodes : Array
var _position
var _bussy

func _init():
	_bussy = false

func build(position,object):
	set_position(position)
	if object:
		bussy()

func add_node(node):
	_adyacent_nodes.append(node)

func set_position(position):
	_position = position

func get_position():
	return _position

func bussy():
	_bussy = true
