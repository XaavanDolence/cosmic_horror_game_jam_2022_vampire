extends Actor

class_name PushableBlock

func _physics_process(delta: float) -> void:
	_velocity.y = _velocity.y + (gravity * get_physics_process_delta_time())
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_velocity.x = 0.0
	
func slide(vector):
	_velocity.x = vector.x * 0.5 # Blocks push at half speed. 
