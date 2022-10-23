extends Actor
class_name Player

onready var _animated_sprite = $AnimatedSprite
const Blood_Projectile = preload("res://src/actors/BloodProjectile.tscn")

const GLIDE_MULTIPLIER = 0.825
const FALL_DEFAULT = 1.0
var fall_multiplier = 1.0
var facing = 1.0


var MAX_SPIT = 3 # Maximum amount of spit allowed on screen
var spit_list = []

# needed to initial spit_list to proper size
func _ready():
	spit_list.resize(MAX_SPIT)

# handle spit mechanics 
func spawn_spit():
	for i in range(0, MAX_SPIT): 
		# only create spit when there is an open slot in spit_list
		if !is_instance_valid(spit_list[i]):
			spit_list[i]=Blood_Projectile.instance()
			get_parent().add_child(spit_list[i])
			spit_list[i].position = position + Vector2(0, -40) # -40 is about where the mouth is
			spit_list[i].set_direction(facing+0.3*get_direction_x())
			# forgive me lord, for I have sinned
			break # without the break all 3 spits will appear in the same place




func _handle_move_input():
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	_velocity =  move_and_slide(Vector2(calculate_xcomp(), calculate_ycomp(is_jump_interrupted)), FLOOR_NORMAL)

func _handle_sprite_rotation():
	var direction_x  = get_direction_x()
	if direction_x != 0:
		_animated_sprite.set_flip_h(direction_x < 0)
		_animated_sprite.get_child(0).set_flip_h( direction_x < 0 )

func get_direction_x():
	var new_facing = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	if new_facing != 0:
		facing = new_facing
	return new_facing

func calculate_xcomp():
	return speed.x * get_direction_x()

func get_direction_y():
	return -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0

func calculate_ycomp(is_jump_interrupted):
	var new_y = _velocity.y + (gravity * get_physics_process_delta_time())
	new_y *= fall_multiplier
	return new_y



