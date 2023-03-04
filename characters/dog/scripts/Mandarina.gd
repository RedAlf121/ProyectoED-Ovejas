extends KinematicBody2D

signal woof

signal stop_barking
var velocity = Vector2(0,-1)
export(float)var speed = 500
export (float) var rotar = 0.0

func _ready():
	pass

func mover():	
	if(rotar == 0):
		velocity = Vector2(0,-1)
	if(rotar == 90):
		velocity = Vector2(1,0)
	if(rotar == 180):
		velocity = Vector2(0,1)
	if(rotar == 270):
		velocity = Vector2(-1,0)	
	move_and_slide(velocity*speed)

func girar_izq():	
	rotar-=90
	if(rotar>=360):
		rotar-=360
	if(rotar<0):
		rotar = 270
	rotation_degrees = rotar

func girar_der():
	rotar+=90
	if(rotar>=360):
		rotar-=360
	rotation_degrees = rotar

func ladrar():
	emit_signal("woof")
	$AudioStreamPlayer.play()
	$AudioStreamPlayer/Timer.start()







func _on_Timer_timeout():
	$AudioStreamPlayer.stop()


func _on_Timer2_timeout():
	emit_signal("stop_barking")
