extends StaticBody2D
var font
func _ready():
	font = FontFile.new()
	font.font_data = load("res://docs/dupix/dupix.ttf")
	font.fixed_size = 16

#variable vie arbre
@export var max_health: float = 100
@onready var health = max_health: set = _set_health
@onready var Invulnerable_Timer = $InvulnerableTimer
var Hautdestroy = false
var candie = false
signal health_updated(health)
signal killed()

#variable Transparence 


func _physics_process(_delta):

	pass

#Fade in
func _on_Area2D_body_entered(body):
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	if body.get_name() == "Player"	and Hautdestroy != true:
		tween.tween_property($Haut, "modulate", Color(1,1,1,.5), 0.25)
		tween.tween_property($Bas, "modulate", Color(1,1,1,.5), 0.25)
		tween.play()
#Fade out
func _on_Area2D_body_exited(body):
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	if body.get_name() == "Player" and Hautdestroy != true:
		tween.tween_property($Haut, "modulate", Color(1,1,1,1), 0.25)
		tween.tween_property($Bas, "modulate", Color(1,1,1,1), 0.25)
		tween.play()

#degat
func damage(amount):
	if Invulnerable_Timer.is_stopped():
		Invulnerable_Timer.start()
		_set_health(health - amount)
		if Hautdestroy != true:
			var inst = load("res://Scene/LeafParticle.tscn").instantiate()
			add_child(inst)
			$Haut/hitfall.play("hit")
		if Hautdestroy == true:
			$Bas/AnimationPlayer.play("hit2")


#quand il est mort
func kill():
		#queue_free()
	pass
	
#statue de la vie
func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	#update()
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			$Haut/hitfall.play("fall")
			if Hautdestroy != true:
				var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
				tween.tween_property($Ombre, "modulate", Color(1,1,1,0), 1)
				Hautdestroy = true
				$Bas.modulate.a = 1
				$Haut.modulate.a = 1
				tween.play()
			kill()
			emit_signal("killed")

#affiche ça vie
func _draw( ):
	draw_string(font,Vector2(-12,12),str(health))
 
#haut de l'arbre destroy
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fall":
		candie = true
		$Haut.hide()
