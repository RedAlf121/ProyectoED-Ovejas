extends Node


var queue : Queue

func _ready():
	queue = Queue.new()
	queue.push(5)
	queue.push(4)
	queue.push(3)
	while(!queue.is_empty()):
		print(queue.pop())
