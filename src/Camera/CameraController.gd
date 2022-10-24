extends Camera2D

onready var player = $"../KinematicBody2D"
var locked = false

func _ready():
	pass

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not locked):
		position.x = player.position.x
		position.y = player.position.y

func changeZoom(val):
	zoom = Vector2(val, val)
