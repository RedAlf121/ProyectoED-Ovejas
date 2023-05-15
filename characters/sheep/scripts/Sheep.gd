class_name Sheep extends CharacterBody2D

signal senal

func _ready():
	pass # Replace with function body.



func _on_Vision_Range_body_entered(body):
	if body != self:
		emit_signal("senal")
		pass # Replace with function body.
