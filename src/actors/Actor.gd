extends KinematicBody2D
class_name Actor

# Gravity
export var speed := Vector2(500.0, 900.0)
export var gravity := 3000.0
var _velocity :=  Vector2.ZERO

var FLOOR_NORMAL := Vector2.UP
