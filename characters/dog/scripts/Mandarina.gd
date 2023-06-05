extends KinematicBody2D

signal woof
signal stop_barking

onready var ani = $AnimationPlayer
var direction = Vector2(0,-1)
export(float)var speed = 500
export (float) var rotar = 0.0
export (float) var tween_time = 0.37
onready var stop = false


onready var collision_detector = $Area2D
func _ready():
	direction_by_rotation()
	idle_movement()
func mover():
	if !stop:
		direction_by_rotation()
		var final_position = position+direction*speed
		motion_movement()
		while(position != final_position):
			position+=direction
			yield(get_tree().create_timer(tween_time),"timeout")
		idle_movement()

func direction_by_rotation():
	if(rotar == 0):
		direction = Vector2(0,-1)
	elif(rotar == 90):
		direction = Vector2(1,0)
	elif(rotar == 180):
		direction = Vector2(0,1)
	elif(rotar == 270):
			direction = Vector2(-1,0)
	$Area2D.position = 64*direction
func motion_movement():
	match(direction):
		Vector2.UP:
			ani.play("UpWalk")
		Vector2.RIGHT:
			ani.play("RightWalk")
		Vector2.DOWN:
			ani.play("DownWalk")
		Vector2.LEFT:
			ani.play("LeftWalk")
			
func idle_movement():
	if(rotar == 0):
			$AnimationPlayer.play("UpIdle")
	if(rotar == 90):
		$AnimationPlayer.play("RightIdle")
	if(rotar == 180):
		$AnimationPlayer.play("DownIdle")
	if(rotar == 270):
		$AnimationPlayer.play("LeftIdle")
			
	
func girar_izq():
	rotar-=90
	if(rotar>=360):
		rotar-=360
	if(rotar<0):
		rotar = 270
	idle_movement()
	direction_by_rotation()

func girar_der():
	rotar+=90
	if(rotar>=360):
		rotar-=360
	idle_movement()
	direction_by_rotation()


func ladrar():
	emit_signal("woof")
	$AudioStreamPlayer.play()
	$AudioStreamPlayer/Timer.start()
	woof()
	
func woof():
	if(rotar == 0):
		$AnimationPlayer.play("UpWoof")
	if(rotar == 90):
		$AnimationPlayer.play("RightWoof")
	if(rotar == 180):
		$AnimationPlayer.play("DownWoof")
	if(rotar == 270):
		$AnimationPlayer.play("LeftWoof")





func _on_Timer_timeout():
	$AudioStreamPlayer.stop()
	if(rotar == 0):
		$AnimationPlayer.play("UpIdle")
	if(rotar == 90):
		$AnimationPlayer.play("RightIdle")
	if(rotar == 180):
		$AnimationPlayer.play("DownIdle")
	if(rotar == 270):
		$AnimationPlayer.play("LeftIdle")


func _on_Timer2_timeout():
	emit_signal("stop_barking")



func _on_Area2D_body_entered(body):
	stop = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	stop = false
	pass # Replace with function body.
