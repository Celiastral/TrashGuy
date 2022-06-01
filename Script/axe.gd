extends Sprite

#VARIABLE
signal axehit
var movedir = Vector2(0,0)
var mousedir = Vector2()
var pdir = false
func _ready() -> void:
	var main_camera = get_node("/root/TestMap/YSort/Player/Camera2D")
	self.connect("axehit",main_camera,"axe_hitted")

func _process(_delta):
	AxeHit()
#ATTACK
func AxeHit():
	if Input.is_action_just_pressed("mouse"):
		print("a")
		$AxeAttack.play("attack")
		pdir = true
func _on_AxeAttack_animation_finished(anim_name):
	pdir = false
	pass 
func _on_hitbox_body_entered(body):
	if body.has_method("damage"):
		body.damage(25)
		emit_signal("axehit")
