class_name Sheep extends KinematicBody2D

signal run

export(float) var speed
onready var move_detector = $MoveDetector
onready var sheep_detector = $SheepDetector
onready var collision_shape_move_detector = $MoveDetector/CollisionShape2D
onready var collision_shape_2d_dog_detector = $DogDetector/CollisionShape2D
onready var final_position = position
onready var stop = true
onready var reverse = false
onready var timer = $Timer
onready var endzone = false#para que detecte la meta una unica vez debido a que la componente de move_detector se reutiliza
var next
var previous

var previous_rotation
var tween_time = 0.37
var direction
var path
func _ready():
	direction_by_rotation()

func rotation_by_direction():
	match(direction):
		Vector2.LEFT:
			rotation_degrees = 0
		Vector2.RIGHT:
			rotation_degrees = 180
		Vector2.UP:
			rotation_degrees = 90
		Vector2.DOWN:
			rotation_degrees = 270

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
	if(next == null):
		stop = false
		sheep_detector.monitoring = true
		reverse = false
		move_near()
	else:
		var head = _find_head()
		head.stop = false
		head.sheep_detector.monitoring = true
		head.reverse = false
		head.move_near()

func _find_head():
	var head = self
	while(head.next != null):
		head = head.next
	return head

func _process(delta):
	if(!stop):
		move_detector.global_position+=direction*speed
	elif(reverse):
		move_detector.global_position = next.position - next.direction*speed
		if(path == null):
			emit_signal("run",self,move_detector.global_position)

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

func _on_MoveDetector_area_entered(area):
	if(area.is_in_group("endzone") and !endzone):
		stop = true
		endzone = true
		emit_signal("run",self,move_detector.global_position)

func connect_sheeps(sheep):
	next = sheep
	sheep.previous = self

func move_near():
	var it_next = next
	var it_previous = previous
	while(it_next != null):
		it_next.stop = false
		it_next.endzone = false
		it_next = it_next.next
	while(it_previous != null):
		it_previous.stop = false
		it_previous.endzone = false
		it_previous = it_previous.previous



func follow_path():
	var tween_time = 0.37
	if(path!=null):
		if(!path.empty()):
			print(path)
			var i = path.pop_front()
			var direction = Vector2(sign(int(position.x - i.get_global_position().x)),sign(int(position.y - i.get_global_position().y)))
			direction = direction.normalized()
			self.direction = direction
			rotation_by_direction()
			var tween = get_tree().create_tween()
			tween.tween_property(self,"position", i.get_global_position(), tween_time)
			yield(get_tree().create_timer(tween_time),"timeout")
		else:
			timer.stop()
			move_detector.global_position = position
	else:
		timer.stop()
		move_detector.global_position = position


func _on_SheepDetector_body_entered(body):
	if(body.is_in_group("sheep") and !reverse and body != self):
		timer.stop()
		sheep_detector.monitoring = false
		path = null
		var it = body
		while(it.previous != null):
			it = it.previous
		connect_sheeps(it)
		reverse = true


func _on_MoveDetector_body_entered(body):
	if(body == self):
		reverse = false
		sheep_detector.monitoring = false
		rotation_degrees = next.rotation_degrees if next != null else rotation_degrees
		direction_by_rotation()


