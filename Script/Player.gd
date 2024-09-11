extends CharacterBody2D
#bordel
var movedir = Vector2(0,0)
@export var speed = 125
var spritedir = "down"
#var dash
@export var dashspeed = 250
var can_dash = true
var dashcooldown = false

#func _ready():
#	pass

func _physics_process(_delta):
	
	control_loop()
	movement_loop()
	Animation_Loop()
	
	if movedir != Vector2(0,0):
		anime_switch("walk")
		
	else:
		anime_switch("idle")
		
#	if can_dash == false:
#		anime_switch("dash")

func control_loop():

	var right = Input.is_action_pressed("ui_right")
	var left  = Input.is_action_pressed("ui_left")
	var up 	  = Input.is_action_pressed("ui_up")
	var down  = Input.is_action_pressed("ui_down")
	var space = Input.is_action_just_pressed("Dash")
	
	movedir.x = -int(left) + int(right)
	movedir.y = -int(up) + int(down)
	
	if dashcooldown == false:			#dash
		if space:
			dashcooldown = true
			can_dash = false
			dash()
			
	#Rage quit
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("reload"):
		get_tree().reload_current_scene()

func movement_loop():

	var motion = movedir.normalized() * speed
# warning-ignore:return_value_discarded
	set_velocity(motion)
	#set_up_direction(Vector2(0,0))
	move_and_slide()

func Animation_Loop():
	match movedir:
		Vector2(-1,0):
			spritedir = "left"
		Vector2(1,0):
			spritedir = "right"
		Vector2(0,1):
			spritedir = "down"
		Vector2(0,-1):
			spritedir = "up"
		Vector2(-1,-1):
			spritedir = "diagl"
		Vector2(-1,1):
			spritedir = "left"
		Vector2(1,-1):
			spritedir = "diagr"
		Vector2(1,1):
			spritedir = "right"

func anime_switch(animation):
	var newanim = str(animation,spritedir)
	if $anim2.animation != newanim:
		$anim2.play(newanim)
		
		
func dash():
	$DashTimer.start()
	$Dashcooldown.start()
	match movedir:
		Vector2(1, 0):			#droite
			speed = +dashspeed
		Vector2(0, 1):			#bas
			speed = +dashspeed
		Vector2(-1, 0):			#gauche
			speed = +dashspeed
		Vector2(0, -1):			#haut
			speed = +dashspeed
		Vector2(1, 1):			#basdroite
			speed = +dashspeed
		Vector2(-1, 1):			#basgauche
			speed = +dashspeed
		Vector2(1,-1):			#hautdroite
			speed = +dashspeed
		Vector2(-1, -1):		#hautgauche
			speed = +dashspeed

func _on_DashTimer_timeout():
	speed = 125
	can_dash = true

func _on_Dashcooldown_timeout():
	dashcooldown = false
