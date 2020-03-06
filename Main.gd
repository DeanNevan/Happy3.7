extends Node2D

var zi

var tail_size = 160
var points_array = []
var colors_array = []

func _draw():
	if points_array.size() < 2:
		return
	colors_array = []
	for i in points_array.size():
		colors_array.append(Color(Global.bird_color.r, 
								  Global.bird_color.g,
								  Global.bird_color.b,
								  0.9 * float(i) / float(points_array.size()))
							)
	#print(points_array)
	#print(colors_array)
	draw_polyline_colors(points_array, colors_array, 3, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	zi = $nv
	$Bird.global_position = zi.get_node("StartPosition").global_position
	$Bird.connect("drag", self, "_on_bird_drag")
	$Bird.connect("fly", self, "_on_bird_fly")
	
	$nv.connect("light_ok", self, "_on_nv_ok")
	$sheng.connect("light_ok", self, "_on_sheng_ok")
	$jie.connect("light_ok", self, "_on_jie_ok")
	$kuai.connect("light_ok", self, "_on_kuai_ok")
	$le.connect("light_ok", self, "_on_le_ok")
	#_on_le_ok()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.playing or Global.ending:
		return
	if zi != null:
		$GUI/Label.text = "已点亮灯光：" + str(zi.lights_count) + "  /  " + str(zi.max_lights_count)
	tail_size = Global.tail_size
	update()
	if points_array.size() < tail_size:
		points_array.append($Bird.position)
	else:
		points_array.pop_front()
		points_array.append($Bird.position)
	
	$Camera2D.position = $Bird.position

func _on_bird_drag():
	$Camera2D.smooth_zoom(Vector2(0.4, 0.4), 0.3)

func _on_bird_fly():
	$Camera2D.smooth_zoom(Vector2(0.25, 0.25), 0.8)
	pass

func _on_nv_ok():
	var origin_position = $Bird.global_position
	$Bird.global_position = $sheng/StartPosition.global_position
	zi = $sheng
	points_array = []
	var moved_vector = $Bird.global_position - origin_position
	for i in tail_size:
		points_array.append(i * (moved_vector / tail_size))

func _on_sheng_ok():
	var origin_position = $Bird.global_position
	$Bird.global_position = $jie/StartPosition.global_position
	zi = $jie
	points_array = []
	var moved_vector = $Bird.global_position - origin_position
	for i in tail_size:
		points_array.append(i * (moved_vector / tail_size))

func _on_jie_ok():
	var origin_position = $Bird.global_position
	$Bird.global_position = $kuai/StartPosition.global_position
	zi = $kuai
	points_array = []
	var moved_vector = $Bird.global_position - origin_position
	for i in tail_size:
		points_array.append(i * (moved_vector / tail_size))

func _on_kuai_ok():
	var origin_position = $Bird.global_position
	$Bird.global_position = $le/StartPosition.global_position
	zi = $le
	points_array = []
	var moved_vector = $Bird.global_position - origin_position
	for i in tail_size:
		points_array.append(i * (moved_vector / tail_size))

func _on_le_ok():
	Global.ending = true
	$Camera2D.smooth_zoom(Vector2(4.5, 4.5), 2)
	$Camera2D.position = $Endposition.position
	$kuai/Label.visible = false
	points_array = []
	update()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	for i in $nv/Lights.get_children():
		#print("nv!")
		i.visible = true
		i.enabled = true
		i.smooth_generate()
		yield(get_tree().create_timer(0.07), "timeout")
	for i in $sheng/Lights.get_children():
		#print("sheng!")
		i.visible = true
		i.enabled = true
		i.smooth_generate()
		yield(get_tree().create_timer(0.07), "timeout")
	for i in $jie/Lights.get_children():
		#print("jie!")
		i.visible = true
		i.enabled = true
		i.smooth_generate()
		yield(get_tree().create_timer(0.07), "timeout")
	for i in $kuai/Lights.get_children():
		#print("kuai!")
		i.visible = true
		i.enabled = true
		i.smooth_generate()
		yield(get_tree().create_timer(0.07), "timeout")
	for i in $le/Lights.get_children():
		#print("le!")
		i.visible = true
		i.enabled = true
		i.smooth_generate()
		yield(get_tree().create_timer(0.07), "timeout")
	$GUI/FakeBird.fly(Vector2(1, 0), 230)
	yield(get_tree().create_timer(0.6), "timeout")
	$GUI/Ding.run(4.05 * 60)
	$GUI/EndLabel.smooth_display(0.185)
	pass
