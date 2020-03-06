extends AnimatedSprite

onready var WorldEnvironment =  get_parent().get_parent().get_node("WorldEnvironment")

var window_size = Vector2(1024, 600)

var running = false

var speed = 4

var Tween1 = Tween.new()
func _ready():
	get_parent().get_node("ColorRect").visible = true
	add_child(Tween1)
	Tween1.interpolate_property(get_parent().get_node("ColorRect"), "modulate", Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	#get_viewport().connect("size_changed", self, "_on_window_size_changed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running:
		position.x += speed * delta
	pass

func run(speed1):
	speed = speed1
	animation = "run"
	running = true
