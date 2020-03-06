extends RigidBody2D

signal fly
signal drag

enum STATE{
	FLYING
	DRAGGING
	IDLE
}

var basic_speed = 180



var drag_point = Vector2()
var drag_time = 0.6
var max_drag_length = 60

var state = STATE.IDLE

var LightScene = preload("res://Light.tscn")
var Lights = []
var light_point = Vector2()
var light_seperation = 100

var is_in_light_area = false

var DirectionArrow = preload("res://DirectionArrow.tscn").instance()

onready var TimerDrag = Timer.new()
onready var TweenSpeed = Tween.new()
onready var TweenLight = Tween.new()
func _draw():
	
	pass

func _ready():
	light_point = global_position
	add_child(TimerDrag)
	TimerDrag.one_shot = true
	$AnimatedSprite.animation = "circle"
	$CPUParticles2D.emitting = false
	$CPUParticles2D2.emitting = false
	$CPUParticles2D3.emitting = false
	get_parent().call_deferred("add_child", DirectionArrow)
	add_child(TweenSpeed)
	add_child(TweenLight)
	pass # Replace with function body.

func _unhandled_input(event):
	if !Global.playing or Global.ending:
		return
	if event.is_action_pressed("left_mouse_button"):
		if state != STATE.DRAGGING:
			change_state(STATE.DRAGGING)
	if event.is_action_released("left_mouse_button"):
		if state != STATE.FLYING:
			change_state(STATE.FLYING)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.playing or Global.ending:
		return
	if (global_position - light_point).length() > light_seperation:
		#yield(get_tree(), "idle_frame")
		var areas = $Area2D.get_overlapping_areas()
		yield(get_tree(), "idle_frame")
		#print(areas)
		var _temp = false
		for i in areas:
			if i.get_parent().has_method("move_to_nearest_standard_point"):
				_temp = true
		if !_temp:
			var new_light = LightScene.instance()
			new_light.global_position = global_position
			new_light.modulate = modulate
			new_light.color = modulate
			get_parent().zi.get_node("Lights").add_child(new_light)
			light_point = global_position
	if linear_velocity.length() > 10 and $AnimatedSprite.animation != "bird" and state == STATE.FLYING:
		$AnimatedSprite.animation = "to_bird"
	if linear_velocity.length() <= 10 and $AnimatedSprite.animation != "circle":
		$AnimatedSprite.animation = "to_circle"
	if $AnimatedSprite.animation == "to_bird" and $AnimatedSprite.frame == 5 and state == STATE.FLYING:
		$AnimatedSprite.animation = "bird"
	if $AnimatedSprite.animation == "to_circle" and $AnimatedSprite.frame == 5:
		$AnimatedSprite.animation = "circle"
		#state = STATE.IDLE
		$CPUParticles2D.emitting = false
		$CPUParticles2D2.emitting = false
		$CPUParticles2D3.emitting = false
	if !TweenLight.is_active():
		smooth_change_light(0.6 + 1 * (linear_velocity.length() / max_drag_length), 0.3 + 0.4 * (linear_velocity.length() / max_drag_length), 0.2)
	if linear_velocity.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	modulate = Global.bird_color
	$Light2D.color = modulate
	match state:
		STATE.DRAGGING:
			#print("2")
			if Input.is_action_pressed("left_mouse_button"):
				#print("1")
				linear_velocity = (global_position - get_global_mouse_position()).normalized() * (TimerDrag.time_left / drag_time) * basic_speed / 3
				DirectionArrow.visible = true
				DirectionArrow.global_position = global_position
				DirectionArrow.scale.x = 0.1 * (drag_time - TimerDrag.time_left) / drag_time
				DirectionArrow.global_rotation = (get_global_mouse_position() - global_position).angle()
				DirectionArrow.modulate = modulate
				$CPUParticles2D.emitting = false
				$CPUParticles2D2.emitting = false
				$CPUParticles2D3.emitting = false
				rotate_object($AnimatedSprite, 10, (get_global_mouse_position() - global_position).normalized(), delta)
				#rotation_degrees = (get_global_mouse_position() - global_position).angle()
		STATE.FLYING:
			#print("3")
			#rotation_degrees = linear_velocity.angle()
			DirectionArrow.visible = false
			$CPUParticles2D.emitting = true
			$CPUParticles2D2.emitting = true
			$CPUParticles2D3.emitting = true
			DirectionArrow.visible = false
			rotate_object($AnimatedSprite, 10, (linear_velocity).normalized(), delta)
			if Input.is_action_pressed("right_mouse_button"):
				var origin_degree = linear_velocity.angle()
				linear_velocity = linear_velocity.rotated((linear_velocity.angle_to(get_global_mouse_position() - global_position)) / 18)
				var changed_degree = abs(linear_velocity.angle() - origin_degree)
				linear_velocity = linear_velocity.normalized() * (linear_velocity.length() - changed_degree * 2.8)
			pass
		STATE.IDLE:
			DirectionArrow.visible = false

func change_state(target_state):
	if target_state == STATE.DRAGGING:
		if state == STATE.FLYING:
			TweenSpeed.interpolate_property(self, "linear_velocity", linear_velocity, Vector2(0, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
			TweenSpeed.start()
			yield(TweenSpeed, "tween_completed")
		drag_point = position
		state = STATE.DRAGGING
		TimerDrag.start(drag_time)
		emit_signal("drag")
	if target_state == STATE.FLYING:
		#print("change_state", target_state)
		fly(get_global_mouse_position() - global_position, (drag_time - TimerDrag.time_left) / drag_time * basic_speed)
		state = STATE.FLYING
		emit_signal("fly")
		pass
	
	pass

func fly(direction, speed):
	linear_velocity = direction.normalized() * speed

func smooth_change_light(target_energy, target_scale, change_speed):
	TweenLight.stop_all()
	TweenLight.interpolate_property($Light2D, "energy", $Light2D.energy, target_energy, change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLight.interpolate_property($Light2D, "scale", $Light2D.texture_scale, target_scale, change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLight.start()

func rotate_object(object, speed, target_direction, delta):
	var present_direction = Vector2(1, 0).rotated(object.global_rotation)
	object.global_rotation = present_direction.linear_interpolate(target_direction, speed * delta).angle()
