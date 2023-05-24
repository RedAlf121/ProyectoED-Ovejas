class_name Sheep extends KinematicBody2D

signal stop_moving
signal run

export(float) var speed
onready var move_detector = $MoveDetector
onready var collision_shape_move_detector = $MoveDetector/CollisionShape2D
onready var collision_shape_2d_dog_detector = $DogDetector/CollisionShape2D
onready var final_position = position
onready var stop = true

var next
var previous

var previous_rotation
var tween_time = 0.37
var direction

func _ready():
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
	stop = false

func _process(delta):
	if(!stop):
		move_detector.global_position+=direction*speed

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
	if(body.is_in_group("sheep") and body != self):
		stop = true
		emit_signal("run",self,final_position)
	


func _on_MoveDetector_area_entered(area):
	if(area.is_in_group("endzone")):
		stop = true
		emit_signal("run",self,move_detector.global_position)
