extends CanvasLayer

var is_zidonghuanse = true
var auto_change_color_speed = 0.45
var auto_change_color_time = 2#自动换色的间隔

var TimerAutoChangeColor = Timer.new()
var TimerStart = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TimerAutoChangeColor)
	TimerAutoChangeColor.start(auto_change_color_time)
	add_child(TimerStart)
	TimerStart.one_shot = true
	close_picker()
	TimerAutoChangeColor.connect("timeout", self, "_on_TimerAutoChangeColor_timeout")
	$HBoxContainer/MarginContainer/VBoxContainer/Button.connect("pressed", self, "_on_button_pressed")
	$HBoxContainer/MarginContainer/VBoxContainer/ZiDongHuanSe.connect("pressed", self, "_on_ZiDongHuanSe_pressed")
	TimerStart.connect("timeout", self, "_on_TimerStart_timeout")
	$HBoxContainer/ColorPicker.connect("color_changed", self, "_on_ColorPicker_color_changed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("key_space"):
		TimerStart.start(1.3)
	if !is_zidonghuanse:
		Global.smooth_change_color($HBoxContainer/ColorPicker.color, 0.5)
	$HBoxContainer/MarginContainer/VBoxContainer/ZiDongHuanSe.text = "自动换色："
	if is_zidonghuanse:
		$HBoxContainer/MarginContainer/VBoxContainer/ZiDongHuanSe.text += "开"
	else:
		$HBoxContainer/MarginContainer/VBoxContainer/ZiDongHuanSe.text += "关"

func show_picker():
	$HBoxContainer/ColorPicker.visible = true
	$HBoxContainer/MarginContainer/VBoxContainer/Button.text = "收起"

func close_picker():
	$HBoxContainer/ColorPicker.visible = false
	$HBoxContainer/MarginContainer/VBoxContainer/Button.text = "展开"

func _on_button_pressed():
	if $HBoxContainer/ColorPicker.visible:
		close_picker()
	else:
		show_picker()
func _on_TimerStart_timeout():
	if $Introduction.visible:
		$Introduction.visible = false
		$Introduction2.visible = false
		$Introduction3.visible = false
		$Introduction4.visible = false
		Global.playing = true
	else:
		$Introduction.visible = true
		$Introduction2.visible = true
		$Introduction3.visible = true
		$Introduction4.visible = true
		$Introduction4.bbcode_text = "长按两秒空格\n关闭说明"

func _on_ZiDongHuanSe_pressed():
	is_zidonghuanse = !is_zidonghuanse
	pass

func _on_TimerAutoChangeColor_timeout():
	if is_zidonghuanse:
		var origin_color = $HBoxContainer/ColorPicker.color
		var a = auto_change_color_speed
		var target_color = Color(clamp(origin_color.r + rand_range(-a, a), 0, 1), 
								 clamp(origin_color.g + rand_range(-a, a), 0, 1), 
								 clamp(origin_color.b + rand_range(-a, a), 0, 1), 1)
		Global.smooth_change_color(target_color, 0.5)

func _on_ColorPicker_color_changed():
	is_zidonghuanse = false
