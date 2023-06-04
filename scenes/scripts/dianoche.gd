extends CanvasModulate
export(Array) var time = [12,30,0]
export(float) var balance = 1
signal game_over
func _ready():
	$AnimationPlayer.playback_speed = 1/balance
	var Timeinseconds = time[0]* 3600 + time[1]*60 +time[2]
	var currentframe = range_lerp(Timeinseconds,0,86400,0,24)
	$AnimationPlayer.play("dianoche")
	$AnimationPlayer.seek(currentframe,true)



func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("game_over")
