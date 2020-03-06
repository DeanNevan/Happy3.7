extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var TweenZoom = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenZoom)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func smooth_zoom(target_zoom, change_speed):
	TweenZoom.interpolate_property(self, "zoom", zoom, target_zoom, change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenZoom.start()
