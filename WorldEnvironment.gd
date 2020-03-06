extends WorldEnvironment


onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	#environment.adjustment_brightness = 0.01
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func smooth_change_brightness(target_value, change_speed):
	Tween1.interpolate_property(environment, "adjustment_brightness", environment.adjustment_brightness, target_value, change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
