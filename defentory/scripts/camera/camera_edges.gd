extends "res://scripts/control/select_units.gd"

export var pan_speed = 15.0

# export var mouse_pos = Vector2()

export var margin_x = 200.0
export var margin_y = 150.0

# Variaveis para controlar o zoom
export var zoom_speed = 10

export var zoom_max = 2.0
export var zoom_min = 0.5

var zoom_pos = Vector2()
var zoom_factor = 1.5
var zooming = false


func _ready():
	print("Size: ", OS.window_size.x, "/", OS.window_size.y)
	set_camera_limits()
	
func _process(delta):
	if Input.is_key_pressed(KEY_CONTROL):	
		if mouse_pos.x < margin_x:
			position.x = lerp(position.x, position.x - abs(mouse_pos.x - margin_x)/margin_x * pan_speed * zoom.x, pan_speed * delta)
		elif mouse_pos.x > OS.window_size.x - margin_x:
			position.x = lerp(position.x, position.x + abs(mouse_pos.x - OS.window_size.x + margin_x)/margin_x *  pan_speed * zoom.x, pan_speed * delta)
		if mouse_pos.y < margin_y:
			position.y = lerp(position.y, position.y - abs(mouse_pos.y - margin_y)/margin_y * pan_speed * zoom.y, pan_speed * delta)
		elif mouse_pos.y > OS.window_size.y - margin_y:
			position.y = lerp(position.y, position.y + abs(mouse_pos.y - OS.window_size.y + margin_y)/margin_y * pan_speed * zoom.y, pan_speed * delta)
	
	# Dando zoom
	zoom.x = lerp(zoom.x, zoom.x * zoom_factor, zoom_speed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoom_factor, zoom_speed * delta)
	
	# Impedindo que de mais zoom que o permitido
	zoom.x = clamp(zoom.x, zoom_min, zoom_max)
	zoom.y = clamp(zoom.y, zoom_min, zoom_max)
	
	# Impedindo que continue dando zoom sozinho
	# apos deixar de rolar o scroll do mouse
	if not zooming:
		zoom_factor = 1.0
	
func _input(event):	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_factor -= 0.1
				zoom_pos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_factor += 0.1
				zoom_pos = get_global_mouse_position()
		else:
			zooming = false

func set_camera_limits():
	var tile_map = get_node("/root/stage/terrain")
	var map_limits = tile_map.get_used_rect()
	
	var map_cellsize = tile_map.cell_size
	limit_left = map_limits.position.x * map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y
	limit_bottom = map_limits.end.y * map_cellsize.y
	