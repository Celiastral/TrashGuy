extends Camera2D
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
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)

	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)

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
		zoom.x = 0.2 
		zoom.y = 0.2
		
	if event is InputEventMouse:
		mousepos = event.position
		mouseposGlobal = get_global_mouse_position()
		

#EVENT SCREENSHAKE
func axe_hitted():
	$Screenshake.start() #Callable(0.1, 4).bind(8)
