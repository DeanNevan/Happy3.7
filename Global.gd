extends Node

var bird_color = Color.white

var tail_size = 150

var playing = false
var ending = false

var to_who = "你"

onready var TweenColor = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenColor)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func smooth_change_color(target_color, change_speed):
	TweenColor.interpolate_property(self, "bird_color", bird_color, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenColor.start()
	pass
