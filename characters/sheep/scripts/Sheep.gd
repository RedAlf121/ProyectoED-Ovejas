class_name Sheep extends KinematicBody2D

signal stop_moving
signal run

export(float) var speed
onready var move_detector = $MoveDetector
onready var collision_shape_move_detector = $MoveDetector/CollisionShape2D
onready var collision_shape_2d_dog_detector = $DogDetector/CollisionShape2D
onready var timer = $Timer

var next
var previous

var previous_rotation
var tween_time = 0.37
var direction
var can_move = true
var final_position
var standby = true
func _ready():
	#collision_shape_move_detector.disabled = true
	direction_by_rotation()

func direction_by_rotation():
	match(round(rotation_degrees)):
		0.0:
			direction = Vector2.RIGHT
		180.0:
			direction = Vector2.LEFT
		90.0:
			direction = Vector2.DOWN
		270.0:
			direction = Vector2.UP

func start_move():
	standby = false
	$Timer.start()
	move()

func move():
	if(!standby):
		collision_shape_move_detector.disabled = true
		if(can_move):
			final_position = position+direction*speed
		else:
			$Timer.stop()
			final_position = move_detector.global_position+direction*speed
			previous_rotation = rotation_degrees
		moving_detector()
		shortest_path_movement()

func shortest_path_movement():
	collision_shape_move_detector.disabled = false
	yield(get_tree().create_timer(0.01),"timeout")
	var collisions = move_detector.get_overlapping_bodies()
	var i = 0
	var colliding = false
	while(i < collisions.size() and !colliding):
			if(!collisions[i].is_in_group("obstacles")):
				colliding = true
			if(collisions[i].is_in_group("sheep") and collisions[i]!=self):
				$Timer.stop()
				collision_shape_move_detector.disabled = true
			i+=1
	if(!colliding):
		final_position = Vector2(int(final_position.x),int(final_position.y))
		emit_signal("run",self,final_position)
		collision_shape_move_detector.disabled = true
	else:
		$Timer.start()


func moving_detector():
	move_detector.global_position=final_position

func near_dog(dog):
	dog.connect("woof",self,"start_move")

func far_dog(dog):
	dog.disconnect("woof",self,"start_move")


func _on_Area2D_body_entered(body):
	if(body.is_in_group("dog")):
		near_dog(body)


func _on_Area2D_body_exited(body):
	if(body.is_in_group("dog")):
		far_dog(body)



func _on_MoveDetector_body_entered(body):
	if(!standby):
		if(body.is_in_group("sheep") and body != self):
			$Timer.stop()
			var correct = body.position-body.direction*body.speed == position
			if correct:
				emit_signal("stop_moving")
				$Timer.stop()
			else:
				var it = body
				while(it.previous != null and it.previous != self):
					it = it.previous
				it.previous = self
				next = it
				final_position = it.position-it.direction*speed
				moving_detector()
				emit_signal("run",self,final_position)
	if(body.is_in_group("obstacle")):
		can_move = false
		$Timer.start()


func _on_Timer_timeout():
	move()

func restart_timer(error):
	if(!can_move):
		if(error):
			$Timer.start()
		if(previous_rotation != null):
			rotation_degrees = previous_rotation
			move_detector.position = Vector2.ZERO
			direction_by_rotation()
			can_move = true
	else:
		$Timer.start()
		if(next!=null):
			rotation_degrees = next.rotation_degrees
			move_detector.position = Vector2.ZERO
			direction_by_rotation()
	collision_shape_move_detector.disabled = false


func _on_MoveDetector_body_exited(body):
		if(body.is_in_group("obstacle")):
			$Timer.stop()
			can_move = true
			final_position = Vector2(int(final_position.x),int(final_position.y))
			emit_signal("run",self,final_position)
