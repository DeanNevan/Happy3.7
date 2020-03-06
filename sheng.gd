extends Node2D

signal light_ok

var max_lights_count = 27
var lights_count = 0

var emitted = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lights_count = $Lights.get_child_count()
	if !emitted:
		if lights_count >= max_lights_count:
			emitted = true
			emit_signal("light_ok")
			for i in $Lights.get_children():
				i.visible = false
				i.energy = 0
				i.texture_scale = 0
				i.enabled = false
				i.get_node("Sprite").scale = Vector2()
