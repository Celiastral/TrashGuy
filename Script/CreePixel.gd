extends KinematicBody2D
#bordel
var movedir = Vector2.ZERO
export var speed = 50
var spritedir = "down"
var Player = null
var gohere = false;
var is_moving = false;
var randomPoint = Vector2.ZERO
var rng = RandomNumberGenerator.new()
export (float) var max_health = 50
onready var health = max_health setget _set_health
var font
onready var Invulnerable_Timer = $Invulnerable_Timer
signal health_updated(health)
signal killed()
func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://docs/dupix/dupix.ttf")
	font.size = 8
	rng.randomize()

func _physics_process(_delta):
	
	Animation_Loop()
	
	Purchase()
		
	if Player == null:
		movement()
	
	if movedir != Vector2(0,0):
		anime_switch("walk")
		
	else:
		anime_switch("idle")
		

func Animation_Loop():
	var dir = stepify(movedir.angle(), PI/4) /(PI/4)
	dir = wrapi(int(dir),0,8)
	
	match dir:
		4:
			spritedir = "left"
		0:
			spritedir = "right"
		2:
			spritedir = "down"
		6:
			spritedir = "up"
		5:
			spritedir = "diagl"
		3:
			spritedir = "left"
		7:
			spritedir = "diagr"
		1:
			spritedir = "right"

func anime_switch(animation):
	var newanim = str(animation,spritedir)
	if $AnimatedSprite.animation != newanim:
		$AnimatedSprite.play(newanim)
		
		
func movement():

	if gohere == false:
		gohere = true
		is_moving = true
		randomize()
		randomPoint = Vector2(rng.randi_range(-3,3),rng.randi_range(-3,3)).normalized()
		$WalkCooldown.start(rand_range(1,6))

	if is_moving == true :
		
		movedir = move_and_slide(randomPoint) * speed /3
		$Timer.start(rand_range(1,6))
	else:
		movedir = Vector2.ZERO
	
	
func Purchase():
	if Player != null :
		movedir = global_position.direction_to(Player.global_position) * speed
		if (position.distance_to(Player.position) <= 15):
			movedir = Vector2.ZERO
	movedir = move_and_slide(movedir)

func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	update()
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")
			
func damage(amount):
	if Invulnerable_Timer.is_stopped():
		Invulnerable_Timer.start()
		_set_health(health - amount)
		if Player != null:
			knockback() #Player.global_position,amount
			
func knockback(): #source_pos: Vector2,damage_: int
	
	movedir = -movedir * 45 
#	var knockback_direction = source_pos.direction_to(self.global_position)
#	var knockback_strengh = damage_ * 1
#	var knockback_ = knockback_direction * knockback_strengh
#
#	global_position += knockback_
	

func kill():
	queue_free()
	
	
func _on_Area2D_body_entered(body):
	if body.name == "Player" :
		Player = body
		


func _on_Area2D_body_exited(body):
	
	if body.name == "Player" :
		Player = null
		movedir = Vector2.ZERO
	
	


func _on_Timer_timeout():
	gohere = false
	rng.randomize()


func _on_WalkCooldown_timeout():
	is_moving = false
	movedir = Vector2.ZERO

func _draw( ):
	draw_string(font,Vector2(-6,-22),str(health))
