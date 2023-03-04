extends Node2D

export(String, FILE) var level_selector

var list = []
var limit = 5

func _ready():
	if(Singleton.mute == false):
		$AudioStreamPlayer.play()


func _on_Button_pressed():
	get_tree().change_scene(level_selector)

func crecimiento():
	$Canvas/ItemList2.rect_size.y = $Canvas/ItemList2.rect_size.y*2
	limit = limit * 2

func _on_ItemList_item_selected(index):
	if($Canvas/ItemList2.get_item_count() > limit):
		crecimiento()
	if(index == 0):
		$Canvas/ItemList2.add_item("Mover")
		list.push_back("moverse")
	if(index == 1):
		$Canvas/ItemList2.add_item("Girar ->")
		list.push_back("girar_der")
	if(index == 2):
		$Canvas/ItemList2.add_item("Girar <-")
		list.push_back("girar_izq")
	if(index == 3):
		$Canvas/ItemList2.add_item("Ladrar")
		list.push_back("ladrar")
	


func _on_ItemList2_item_selected(index):
	$Canvas/ItemList2.remove_item(index)
	list.pop_at(index)





func finished():
	$Mandarina.position = $Position2D.position
	$Mandarina.rotar = 0
	$Mandarina.rotation_degrees = 0
	$ControlCommands/Timer.stop()
