extends RichTextLabel


var _count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	visible_characters = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		_count += 1
		if _count % 5 == 0:
			visible_characters += 1
