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

func _transform(position):
	var size = _nodes[0].size
	return (position-size/2)/size

func shortest_path(position_from, position_to):
	var path = null
	if !_nodes.empty():
		var node_from_position = _find_node(_transform(position_from))
		var node_to_position = _find_node(_transform(position_to))
		if(node_from_position != -1 and node_to_position != -1):
			var node_from = _nodes[node_from_position]
			var node_to = _nodes[node_to_position]
			path = _shortest_path(node_from, node_to)
	return path

func _shortest_path(node_from, node_to):
	var node_map = _bfs(node_from, node_to)
	return _path(node_map, node_to)

func _path(node_map, node):
	var path = []
	path.push_front(node)
	var aux_node = node
	while(node_map.has(aux_node) and node_map[aux_node] != null):
		path.push_front(node_map[aux_node])
		aux_node = path[0]
	return path

func _bfs(node_from, node_to):
	var node_map = {node_from: null}
	var found = false
	var queue_node = Queue.new()
	queue_node.push(node_from)
	while(!queue_node.is_empty() and !found):
		var actual_node = queue_node.pop()
		for i in actual_node.get_adyacent_nodes():
			if(!i.is_bussy() and !node_map.has(i)):
				if(i == node_to): 
					found = true
				queue_node.push(i)
				node_map[i] = actual_node
	return node_map
