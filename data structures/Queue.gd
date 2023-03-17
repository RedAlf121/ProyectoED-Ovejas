class_name Queue extends Node2D

#clase interna nodo
#se va a trabajar como una LinkedList
class QNode:
	var data
	var next

var _head : QNode #cola
var _tail : QNode#referencia al ultimo de la cola
var _size : int

func _init():
	_head = QNode.new()
	_tail = QNode.new()
	_size = 0

func _decrement_size():
	if _size != 0:
		_size-=1

func _increment_size():
	_size+=1

func push(data):
	if is_empty():
		_init()
		_head.data = data
		_tail = _head
	else:
		var new_node = QNode.new()
		new_node.data = data
		_tail.next = new_node
		_tail = new_node
	_increment_size()


func pop():
	var data = self.front()
	_head = _head.next
	_decrement_size()
	return data

func front():
	var data = null
	if(!self.is_empty()):
		data = _head.data
	return data

func is_empty() -> bool:
	return _head == null or _head.data == null

func size() -> int:
	return _size
