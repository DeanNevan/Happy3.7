extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Tween1 = Tween.new()
# Called when the node enters the scene tree for tstahe first time.
func _ready():
	energy = 0
	texture_scale = 0
	$Sprite.scale = Vector2()
	add_child(Tween1)
	Tween1.interpolate_property(self, "energy", energy, 1, 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property(self, "texture_scale", texture_scale, 0.18, 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.2, 0.2), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move_to_nearest_standard_point():
	pass

func smooth_generate():
	Tween1.interpolate_property(self, "energy", energy, 1, 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property(self, "texture_scale", texture_scale, 0.18, 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.2, 0.2), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
