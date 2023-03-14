class_name Graph extends Node


var _nodes : Array


func build_graph(tile : TileMap, obstacles: TileMap):
	var matrix = tile.get_used_cells()
	var cell_size = tile.cell_size
	for i in matrix:
		_build_node(i,cell_size,obstacles)
	_connect_nodes()

func _build_node(position,size,obstacles):
		var node = GNode.new()
		node.build(position,size)
		node.be_bussy(obstacles)
		_nodes.push_back(node)

func _connect_nodes():
	for i in _nodes.size():
		var position = _nodes[i].get_position()
		_add_adyacency(_nodes[i], Vector2(position.x+1,position.y))
		_add_adyacency(_nodes[i], Vector2(position.x-1,position.y))
		_add_adyacency(_nodes[i], Vector2(position.x,position.y+1))
		_add_adyacency(_nodes[i], Vector2(position.x,position.y-1))

func _add_adyacency(node: GNode, position: Vector2):
	var index = _find_node(position)
	if(index != -1):
		node.add_node(_nodes[index])

func _find_node(position: Vector2):
	var index = -1
	var li = 0
	var ls = _nodes.size()-1
	var mid
	var node_position
	while(li <= ls and index == -1):
		mid = (li+ls)/2
		node_position = _nodes[mid].get_position()
		if(node_position == position):
			index = mid
		elif(node_position.y < position.y or (node_position.y == position.y and node_position.x < position.x)):
			li = mid+1
		else:
			ls = mid-1
	return index
