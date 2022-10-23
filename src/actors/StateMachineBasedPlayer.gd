extends Actor
class_name Player

onready var _animated_sprite = $AnimatedSprite

const GLIDE_MULTIPLIER = 0.825
const FALL_DEFAULT = 1.0
var fall_multiplier = 1.0

func _handle_move_input():
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	_velocity =  move_and_slide(Vector2(calculate_xcomp(), calculate_ycomp(is_jump_interrupted)), FLOOR_NORMAL)

func _handle_sprite_rotation():
	var direction_x  = get_direction_x()
	if direction_x != 0:
		_animated_sprite.set_flip_h(direction_x < 0)
		_animated_sprite.get_child(0).set_flip_h( direction_x < 0 )

func get_direction_x():
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func calculate_xcomp():
	return speed.x * get_direction_x()

func get_direction_y():
	return -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0

func calculate_ycomp(is_jump_interrupted):
	var new_y = _velocity.y + (gravity * get_physics_process_delta_time())
	new_y *= fall_multiplier
	return new_y



