extends Area2D

# Constants
const SPEED = 300

# Variables
var target_dir = Vector2()
var velocity = Vector2()

func _ready():
	visible = false

func _physics_process(delta):
	velocity = target_dir * SPEED
	position += velocity * delta

func die():
	queue_free()

func _on_Enemy_body_entered(body):
	if body.name == "Player":
		body.die()
	elif body.name == "Walls" and visible:
		die()

func _on_Enemy_body_exited(body):
	if body.name == "Walls":
		visible = true
