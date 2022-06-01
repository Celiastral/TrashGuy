extends StaticBody2D
var font
func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://docs/dupix/dupix.ttf")
	font.size = 16

#variable vie arbre
export (float) var max_health = 100
onready var health = max_health setget _set_health
onready var Invulnerable_Timer = $InvulnerableTimer
var Hautdestroy = false
var candie = false
signal health_updated(health)
signal killed()

#variable Transparence
onready var tween = get_node("Tween")


func _physics_process(_delta):

	pass

#Fade in
func _on_Area2D_body_entered(body):
	if body.get_name() == "Player"	and Hautdestroy != true:
		tween.interpolate_property($Bas, "modulate",
		Color(1,1,1,1), Color(1,1,1,.5), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property($Haut, "modulate",
		Color(1,1,1,1), Color(1,1,1,.5), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
#Fade out
func _on_Area2D_body_exited(body):
	if body.get_name() == "Player" and Hautdestroy != true:
		tween.interpolate_property($Bas, "modulate",
		Color(1,1,1,.5), Color(1,1,1,1), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property($Haut, "modulate",
		Color(1,1,1,.5), Color(1,1,1,1), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start();
	

#degat
func damage(amount):
	if Invulnerable_Timer.is_stopped():
		Invulnerable_Timer.start()
		_set_health(health - amount)
		if Hautdestroy != true:
			get_node("Particles2D").emitting = true
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
	update()
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			$Haut/hitfall.play("fall")
			if Hautdestroy != true:
				tween.interpolate_property($Ombre, "modulate",
				Color(1,1,1,.5), Color(1,1,1,0), 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				Hautdestroy = true
				$Bas.modulate.a = 1
				$Haut.modulate.a = 1
				tween.start()
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

