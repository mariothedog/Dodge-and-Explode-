extends KinematicBody2D

# Get nodes in the scene
onready var sprite = get_node("Sprite")
onready var collision_shape = get_node("CollisionShape2D")
onready var animation_player = get_node("AnimationPlayer")

# Constant variables
const SPEED = 400

# Variables
var velocity = Vector2()
var input_vel = Vector2()
var dead = false

func _unhandled_input(_event):
	if dead:
		return
	
	input_vel = Vector2()
	input_vel.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vel.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = input_vel.normalized() * SPEED

func _physics_process(_delta):
	move()
	animate()

func move():
	velocity = move_and_slide(velocity)

func animate():
	if input_vel != Vector2.ZERO:
		sprite.rotation = input_vel.angle() + PI/2
	
	if dead:
		return
	
	if abs(velocity.length()) > 1:
		animation_player.play("Run") # TODO
	else:
		animation_player.play("Idle") # TODO

func die():
	collision_shape.set_deferred("disabled", true)
	dead = true
	velocity = Vector2.ZERO
	
	animation_player.play("Die") # TODO
	
	yield(animation_player, "animation_finished")
	
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while reloading the scene.")
