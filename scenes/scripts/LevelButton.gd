extends TextureButton

signal load_level
onready var level = null
var textures = ["res://images/icons/locked.png","res://images/icons/unlocked.png"]
enum level_state{LOCKED=0,UNLOCKED}

func _ready():
	check_lock()

func check_lock():
	var i = int(level != null)
	texture_normal = load(textures[i])

func _on_TextureButton_pressed():
	if(level != null):
		emit_signal("load_level",level)

