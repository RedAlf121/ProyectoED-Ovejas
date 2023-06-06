extends KinematicBody2D

signal woof
signal stop_barking

onready var ani = $AnimationPlayer
var direction = Vector2(0,-1)
export(float)var speed = 500
export (float) var rotar = 0.0
export (float) var tween_time = 0.37
onready var stop = false
onready var size = 64

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
	direction = AnimationManager.selection_cases(rotar,[0,90,180,270],[Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)])
	if(direction != null):
		$Area2D.position = size*direction

func motion_movement():
	AnimationManager.animation_parameters(direction,[Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT],["UpWalk","RightWalk","DownWalk","LeftWalk"],ani)


func idle_movement():
	AnimationManager.animation_parameters(rotar,[0,90,180,270],["UpIdle","RightIdle","DownIdle","LeftIdle"],ani)


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
	AnimationManager.animation_parameters(rotar,[0,90,180,270],["UpWoof","RightWoof","DownWoof","LeftWoof"],ani)





func _on_Timer_timeout():
	$AudioStreamPlayer.stop()
	idle_movement()


func _on_Timer2_timeout():
	emit_signal("stop_barking")



func _on_Area2D_body_entered(body):
	stop = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	stop = false
	pass # Replace with function body.
