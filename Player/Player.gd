extends KinematicBody2D

const SPEED = 400

var velocity = Vector2()

func _unhandled_input(_event):
	var input_vel = Vector2()
	input_vel.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vel.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = input_vel.normalized() * SPEED

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func die():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while reloading the scene.")
