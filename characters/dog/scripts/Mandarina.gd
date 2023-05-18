extends KinematicBody2D

signal woof
signal calm_sheeps
signal stop_barking

var direction = Vector2(0,-1)
export(float)var speed = 500
export (float) var rotar = 0.0
export (float) var tween_time = 0.37

func mover():
	if(rotar == 0):
		direction = Vector2(0,-1)
	if(rotar == 90):
		direction = Vector2(1,0)
	if(rotar == 180):
		direction = Vector2(0,1)
	if(rotar == 270):
		direction = Vector2(-1,0)
	var final_position = position+direction*speed
		#detectar colisiones
	while(position != final_position):
		position+=direction
		yield(get_tree().create_timer(tween_time),"timeout")

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
	emit_signal("calm_sheeps")
	emit_signal("woof")
	$AudioStreamPlayer.play()
	$AudioStreamPlayer/Timer.start()







func _on_Timer_timeout():
	$AudioStreamPlayer.stop()


func _on_Timer2_timeout():
	emit_signal("stop_barking")
