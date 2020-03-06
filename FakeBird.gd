extends RigidBody2D

func _ready():
	$AnimatedSprite.animation = "bird"
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate = Global.bird_color
	$Light2D.color = modulate
	

func fly(direction, speed):
	linear_velocity = direction.normalized() * speed
