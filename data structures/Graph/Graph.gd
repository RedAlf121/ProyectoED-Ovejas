class_name Graph extends Node


var _nodes : Array


func build_graph(tile : TileMap):
	var matrix = tile.get_used_cells()
	var node
	for i in matrix:
		node = GNode.new()
		node.build(i,tile.cell_size,false)
		_nodes.push_back(node)
		
	for i in _nodes.size():
		var position = _nodes[i].get_position()
		_add_adyacency(_nodes[i], Vector2(position.x+1,position.y), matrix)
		_add_adyacency(_nodes[i], Vector2(position.x-1,position.y), matrix)
		_add_adyacency(_nodes[i], Vector2(position.x,position.y+1), matrix)
		_add_adyacency(_nodes[i], Vector2(position.x,position.y-1), matrix)

func _add_adyacency(node: GNode, position: Vector2, matrix: Array):
	var index = _find_node(position)
	if(index != -1):
		node.add_node(_nodes[index])


func _find_node(position: Vector2):
	var index = -1
	var li = 0
	var ls = _nodes.size()-1
	while(li <= ls and index == -1):
		var mid = (li+ls)/2
		var node_position = _nodes[mid].get_position()
		if(node_position == position):
			index = mid
		elif(node_position.y < position.y or (node_position.y == position.y and node_position.x < position.x)):
			li = mid+1
		else:
			ls = mid-1
	return index
