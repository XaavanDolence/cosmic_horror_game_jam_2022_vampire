extends Actor

onready var _animated_sprite = $AnimatedSprite


func _physics_process(delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	var direction := get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	if Input.is_action_pressed("jump") and -_velocity.y < 0:
		_velocity.y *= 0.5
		
	_velocity =  move_and_slide(_velocity, FLOOR_NORMAL)
	
	handle_animation(direction.x, -_velocity.y) # y is inverse for some stupid reason.
	
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)
	

func calculate_move_velocity(
		linnear_velocity: Vector2, 
		direction: Vector2, 
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var new_velocity := linnear_velocity
	new_velocity.x = speed.x * direction.x
	
	new_velocity.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
		
	return new_velocity


# function for handling vampires animation
# 
func handle_animation(xDirection, yDirection):
	# control which way vampire faces
	if xDirection != 0:
		_animated_sprite.set_flip_h(xDirection < 0)
	
	# Behold! The nested elif forest. Gaze upon its beauty.
	# Set animation for different states
	if is_on_floor():
		if xDirection == 0:
			_animated_sprite.play("idle")
		else:
			_animated_sprite.play("walking")
	else:
		if yDirection > 0:
			_animated_sprite.play("jump")
		else:
			if Input.is_action_pressed("jump"):
				_animated_sprite.play("glide")
			else:
				_animated_sprite.play("fall")
	
	# Handling the vampires spit. Ironically this was the hardest part
	var s = _animated_sprite.get_animation()
	_animated_sprite.get_child(0).play(s)
	
	if Input.is_action_pressed("spit"):
		_animated_sprite.get_child(0).set_flip_h(_animated_sprite.is_flipped_h() )
		_animated_sprite.get_child(0).visible = true
	if Input.is_action_just_released("spit"):
		_animated_sprite.get_child(0).visible = false
