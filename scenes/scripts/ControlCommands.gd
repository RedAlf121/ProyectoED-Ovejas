extends Node


signal moverse
signal girar_izq
signal girar_der
signal ladrar


signal finished
onready var signal_queue = Queue.new()
onready var timer = $Timer

func do_commands():
	timer.stop()
	if(!signal_queue.is_empty()):
		emit_signal(signal_queue.pop())
		yield(get_tree().create_timer(1.0), "timeout")
		timer.start()
	else:
		emit_signal("finished")

func fill_signal_queue(var list:Array):
	for i in range(list.size()):
		signal_queue.push(list[i])

func start(list):	
	fill_signal_queue(list)
	timer.start()

func stop_timer():
	timer.stop()
