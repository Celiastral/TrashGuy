extends RayCast2D
#VARIABLE
var movedir = Vector2(0,0)
var mousedir = Vector2()
var pdir = false
func _ready():
	$Slash.hide()

func _process(_delta):
	axedir()
	InputButtom()

#CONTROLE DIR
func InputButtom():
	var right = Input.is_action_pressed("ui_right")
	var left  = Input.is_action_pressed("ui_left")
	var up 	  = Input.is_action_pressed("ui_up")
	var down  = Input.is_action_pressed("ui_down")
	movedir.x = -int(left) + int(right)
	movedir.y = -int(up) + int(down)
	if Input.is_action_just_pressed("mouse"):
		if pdir == false:
			pdir = true
			$Slash.visible = true
			$Slash.play("Slash")

#DIR AXE
func axedir():
	if pdir == false:
		mousedir = get_global_mouse_position()
		var ligne = mousedir - $axe/point.global_position
		var rota = rad_to_deg(ligne.angle())
		if(rota >= -90 and rota <= 90):
			#$axe.flip_v = false
			scale.y = 1
		else:
			scale.y = -1
			#$axe.flip_v = true
		look_at(mousedir)
	if movedir.y == -1 and Vector2() != null:
		$axe.z_index = -1
	else:
		$axe.z_index = 0
	if movedir.y == 1:
		$axe.z_index = 0
func _on_AxeAttack_animation_finished(anim_name):
	if anim_name == "attack":
		pdir = false

func _on_Slash_animation_finished():
	$Slash.stop()
	$Slash.hide()
	
