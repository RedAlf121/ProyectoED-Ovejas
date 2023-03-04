extends Node


signal moverse
signal girar_izq
signal girar_der
signal ladrar


signal finished
onready var signal_queue = Queue.new()

func do_commands():
	if(!signal_queue.is_empty()):
		emit_signal(signal_queue.pop())
	else:
		$Timer.stop()
		emit_signal("finished")

func fill_signal_list(var list:Array):
	for i in range(list.size()):
		signal_queue.push(list[i])

func _on_Button2_pressed():
	fill_signal_list(get_parent().list)
	$Timer.start()
