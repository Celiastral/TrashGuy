extends TextureRect
@export var zoomspeed = 10.0
@export var zoommargin = 0.1

@export var zoomMin = 0.25
@export var zoomMax = 3.0
@export var marginX = 200.0
@export var marginY = 200.0

var mousepos = Vector2()
var mouseposGlobal = Vector2()
var start = Vector2()
var startv = Vector2()
var end = Vector2()
var endv = Vector2()
var zoomfactor = 1.0
var zooming = false
var is_dragging = false
var move_to_point = Vector2()
var back_zoom = .01

func _process(delta):
	#zoom in
	size.x = lerp(size.x, size.x * zoomfactor, zoomspeed * delta)
	size.y = lerp(size.y, size.y * zoomfactor, zoomspeed * delta)

	size.x = clamp(size.x, zoomMin, zoomMax)
	size.y = clamp(size.y, zoomMin, zoomMax)

	if not zooming:
		zoomfactor = 1.0
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
		else:
			zooming = false
	if Input.is_action_pressed("scroll button"):
		size.x = 0.2 
		size.y = 0.2
		
	if event is InputEventMouse:
		mousepos = event.position
		mouseposGlobal = get_global_mouse_position()
