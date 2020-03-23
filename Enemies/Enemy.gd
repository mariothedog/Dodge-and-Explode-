extends KinematicBody2D

const SPEED = 300

var velocity = Vector2()

var target_dir

func _physics_process(_delta):
	movement()

func movement():
	velocity = target_dir * SPEED
	
	velocity = move_and_slide(velocity)

func set_target_dir(target_pos):
	target_dir = position.direction_to(target_pos)
