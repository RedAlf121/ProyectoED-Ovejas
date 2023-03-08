extends Node


onready var _signal_dictionary

func _init():
	_signal_dictionary ={0: "moverse",1: "girar_der",2: "girar_izq",3: "ladrar"}

func get_signal(index)-> String:
	var signal_name = "-/"
	if(_valid_index(index)):
		signal_name = _signal_dictionary[index]
	return signal_name

func _valid_index(index):
	return index>=0 and index < _signal_dictionary.size()
