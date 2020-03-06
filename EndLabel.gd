extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	text += Global.to_who
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate = Global.bird_color
	pass

func smooth_display(speed):
	while true:
		if visible_characters > 40:
			break
		yield(get_tree().create_timer(speed), "timeout")
		visible_characters += 1
