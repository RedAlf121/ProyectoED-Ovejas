class_name Graph extends Node

const _ways = [Vector2.LEFT,Vector2.RIGHT,Vector2.DOWN,Vector2.UP]

var _nodes : Dictionary

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
		if(!node.is_bussy()):
			_nodes[node.get_position()] = node


func _connect_nodes():
	for i in _nodes.keys():
		var position = _nodes[i].get_position()
		for j in _ways:
			_add_adyacency(_nodes[i], position+j)


func _add_adyacency(node: GNode, position: Vector2):
	var index = _find_node(position)
	if(index != null):
		node.add_node(index)


func _find_node(position: Vector2):	
	return _nodes.get(position)


func _transform(position):
	var size = _nodes[_nodes.keys()[0]].size
	return (position-size/2)/size


func shortest_path(position_from, position_to):
	var path = null
	if !_nodes.empty():
		var node_from = _find_node(_transform(position_from))
		var node_to = _find_node(_transform(position_to))
		if(node_from != null and node_to != null):
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
			if(!node_map.has(i)):
				if(i == node_to): 
					found = true
				queue_node.push(i)
				node_map[i] = actual_node
	return node_map
