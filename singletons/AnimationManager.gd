extends Node

func animation_parameters(parameter,cases,list, animation_player):
	var animation = selection_cases(parameter,cases,list)
	if(animation != null):
		animation_player.play(animation)

func selection_cases(parameter, cases, list):
	var result = null
	if(list.size()==cases.size() and list.size() == 4):
		var i = 0
		var stop = false
		while(i < list.size() and !stop):
			if(parameter == cases[i]):
				result = list[i]
				stop = true
			i+=1
	return result
