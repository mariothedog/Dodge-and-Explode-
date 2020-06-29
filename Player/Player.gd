extends KinematicBody2D

# Get nodes in the scene
onready var sprite = get_node("Sprite")
onready var collision_shape = get_node("CollisionShape2D")
onready var animation_player = get_node("AnimationPlayer")

# Constant variables
const SPEED = 400

# Variables
var velocity = Vector2()
var dead = false

func _unhandled_input(_event):
	if dead:
		return
	
	var input_vel = Vector2()
	input_vel.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vel.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = input_vel.normalized() * SPEED

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func die():
	collision_shape.set_deferred("disabled", true)
	dead = true
	velocity = Vector2.ZERO
	
	animation_player.play("Explode")
	
	yield(animation_player, "animation_finished")
	
	sprite.material.set_shader_param("time", 0)
	sprite.material.set_shader_param("segment_color", Color("0d0c0c"))
	
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while reloading the scene.")
