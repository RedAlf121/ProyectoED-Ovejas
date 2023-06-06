extends Node2D






func _process(delta):
	var parent = get_parent()
	if(parent is CanvasModulate):
		modulate = parent.color
