extends StateMachine
class_name PlayerStateMachine
	

func _ready():
	add_state("idle")
	add_state("walking")
	add_state("jump")
	add_state("fall")
	add_state("glide")
	call_deferred("set_state", states.idle)


func _input(event: InputEvent) -> void:
	# Handles sprite rotation.
	parent._handle_sprite_rotation()
	
	# Canceling Jumps
	if [states.jump].has(curr_state) and event.is_action_released("jump"):
		parent._velocity.y = 0.0 # Up is negative.
	# Jumping
	if [states.idle, states.walking].has(curr_state) and event.is_action_pressed("jump"):
		parent._velocity.y = parent.speed.y * -1.0 # Up is negative.
 
	# Spitting
	if [states.idle, states.walking, states.jump, states.fall, states.glide].has(curr_state) and event.is_action_pressed("spit"):
		parent._animated_sprite.get_child(0).visible = true
		parent.spawn_spit()
	if event.is_action_released("spit"):
		parent._animated_sprite.get_child(0).visible = false


func _state_logic(delta):
	parent._handle_move_input()
	parent._handle_pushing()


func _get_transition(delta):
	match curr_state:
		states.idle:
			if !parent.is_on_floor():
				if parent._velocity.y < 0:
					return states.jump
				elif parent._velocity.y > 0 and Input.is_action_pressed("jump"):
					return states.glide
				elif parent._velocity.y > 0:
					return states.fall
			elif parent._velocity.x != 0:
				return states.walking
		states.walking:
			if !parent.is_on_floor():
				if parent._velocity.y < 0:
					return states.jump
				elif parent._velocity.y > 0 and Input.is_action_pressed("jump"):
					return states.glide
				elif parent._velocity.y > 0:
					return states.fall
			elif parent._velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif  parent._velocity.y > 0 and Input.is_action_pressed("jump"):
				return states.glide
			elif  parent._velocity.y > 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent._velocity.y > 0 and Input.is_action_pressed("jump"):
				return states.glide
			elif parent._velocity.y < 0:
				return states.jump
		states.glide:
			if parent.is_on_floor():
				return states.idle
			elif parent._velocity.y > 0 and !Input.is_action_pressed("jump"):
				return states.fall
			elif parent._velocity.y < 0:
				return states.jump

	return null


func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent._animated_sprite.play("idle")
		states.walking:
			parent._animated_sprite.play("walking")
		states.jump:
			parent._animated_sprite.play("jump")
		states.glide:
			parent._animated_sprite.play("glide")
			parent.fall_multiplier = parent.GLIDE_MULTIPLIER # Sets fall multiplier for gliding.
		states.fall:
			parent._animated_sprite.play("fall")


func _exit_state(old_state, new_state):
	match old_state:
		states.glide:
			parent.fall_multiplier = parent.FALL_DEFAULT # Resets fall multiplier for normal fall speed.
