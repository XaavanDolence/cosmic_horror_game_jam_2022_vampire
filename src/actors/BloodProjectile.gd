extends Area2D

onready var splash = $AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BASE_SPEED = 10.0
const GRAVITY = 0.7

var velocity = Vector2(0, -5)

# - : left
# + : right
func set_direction(direction):
	velocity.x = direction * BASE_SPEED

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	velocity.y += GRAVITY
	position += velocity
	

func _on_BloodProjectile_body_entered(body):
	set_physics_process(false)
	splash.play("Splash")
	yield(splash, "animation_finished")
	queue_free()
