extends Node

func animation_parameters(parameter,relation, animation_player):
	var animation = selection_cases(parameter,relation)
	if(animation != null):
		animation_player.play(animation)

func selection_cases(parameter, relation):
	var result = null
	result = relation.get(parameter)
	return result
