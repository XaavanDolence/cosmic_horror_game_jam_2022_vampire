extends KinematicBody2D
class_name Actor

# Gravity
export var speed := Vector2(100.0, 100.0)
export var gravity := 30.0
var velocity :=  Vector2.ZERO

func _physics_process(delta : float) -> void:
		velocity.y += gravity * delta
		
		# Max Move Speed
		velocity.y = max(velocity.y, speed.y)
		velocity.x = max(velocity.x, speed.x)
		
		velocity =  move_and_slide(velocity)