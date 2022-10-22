extends Node
class_name StateMachine


var curr_state = null setget set_state
var prev_state = null
var states = {}

onready var parent = get_parent()

func _physics_process(delta: float) -> void:
	if curr_state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

# Handles changing state logic. 
func set_state(new_state) -> void:
	# pushes to next state.
	prev_state = curr_state
	curr_state = new_state
	# Runs state change rules if states are not null.
	
	if prev_state != null:
		_exit_state(prev_state, curr_state)
	if new_state != null:
		_enter_state(curr_state, prev_state)

# Adds states to the machine. Note: States should never be removed.
# Used for debuging and printing out a list of possible states.
func add_state(state_name) -> void:
	states[state_name] = states.size()

# Virtual Functions to be overwritten by the inherited classes. 
func _state_logic(delta):
	pass
 
# returns a the next state if there is a state change, null otherwise.
func _get_transition(delta):
	return null
	
func _enter_state(new_state, old_state):
	pass
	
func _exit_state(old_state, new_state):
	pass
# End of Virtual Functions.
