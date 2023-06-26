class_name Sheep extends KinematicBody2D

signal run

enum direction_cases {ARRIBA,ABAJO,IZQUIERDA,DERECHA}
export(float) var speed
export(direction_cases) var enum_direction
onready var move_detector = $MoveDetector
onready var sheep_detector = $SheepDetector
onready var collision_shape_move_detector = $MoveDetector/CollisionShape2D
onready var collision_shape_2d_dog_detector = $DogDetector/CollisionShape2D
onready var final_position = position
onready var stop = true
onready var reverse = false
onready var timer = $Timer
onready var endzone = false#para que detecte la meta una unica vez debido a que la componente de move_detector se reutiliza
var direction
var next
var previous
onready var ani = $AnimationPlayer

var previous_rotation
var tween_time = 0.37
export(float) var path_time = 0.43
var path
func _ready():
	match(enum_direction):
		direction_cases.ARRIBA:
			direction = Vector2.UP
		direction_cases.ABAJO:
			direction = Vector2.DOWN
		direction_cases.IZQUIERDA:
			direction = Vector2.LEFT
		direction_cases.DERECHA:
			direction = Vector2.RIGHT
	idle_animation()
	timer.wait_time = path_time


func walk_animation():
	AnimationManager.animation_parameters(direction,{Vector2.LEFT:"LeftWalk",Vector2.RIGHT:"RightWalk",Vector2.UP:"UpWalk",Vector2.DOWN:"DownWalk"},ani)
	sheep_detector.position = direction*speed/2

func idle_animation():
	AnimationManager.animation_parameters(direction,{Vector2.LEFT:"LeftIdle",Vector2.RIGHT:"RightIdle",Vector2.UP:"UpIdle",Vector2.DOWN:"DownIdle"},ani)
	sheep_detector.position = direction*speed/2

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
	#var tween_time = 0.37
	if(path!=null):
		if(!path.empty()):
			var i = path.pop_front()
			var direction = Vector2(sign(int(position.x - i.get_global_position().x)),sign(int(position.y - i.get_global_position().y)))
			direction = direction.normalized()*-1
			self.direction = direction
			walk_animation()
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
		timer.wait_time = 0.43
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
		direction = next.direction if next != null else direction
		idle_animation()


