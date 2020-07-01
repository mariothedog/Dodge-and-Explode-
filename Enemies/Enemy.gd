extends Area2D

# Constant variables
const SPEED = 300

# Variables
var target_dir = Vector2()
var velocity = Vector2()

func _ready() -> void:
	visible = false

func _physics_process(delta) -> void:
	velocity = target_dir * SPEED
	position += velocity * delta

func die() -> void:
	queue_free()

func _on_Enemy_body_entered(body) -> void:
	if body.name == "Player":
		if body.can_kill:
			die()
		else:
			body.die()
	elif body.name == "Walls" and visible:
		die()

func _on_Enemy_body_exited(body) -> void:
	if body.name == "Walls":
		visible = true
