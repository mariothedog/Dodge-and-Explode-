extends Area2D

const SPEED = 300

var target_dir = Vector2()

var velocity = Vector2()

func _physics_process(delta):
	velocity = target_dir * SPEED
	position += velocity * delta

func _on_Enemy_body_entered(body):
	body.die()
