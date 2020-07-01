# Credit to Game Endeavor
# https://youtu.be/6_EwotQJCfY
# This script is an edited version of their implementation

extends Node

const END_SPEED = 1
var slow_mo_enabled = false
var slow_mo_fade_out = false
var stopped_time
var fade_duration_ms
var start_speed

var temporary_start_enabled = false
var temporary_start_time
var temporary_start_duration_ms

func _process(_delta):
	if temporary_start_time:
		if slow_mo_fade_out: # If the stop command is used to end it early
			temporary_start_time = false
		else:
			var current_time = OS.get_ticks_msec() - temporary_start_time
			if current_time >= temporary_start_duration_ms:
				temporary_start_time = false
				stop(fade_duration_ms / 1000.0)
	
	if slow_mo_fade_out:
		var current_time = OS.get_ticks_msec() - stopped_time
		var time_scale = circ_ease_in(current_time, start_speed, END_SPEED, fade_duration_ms)
		if current_time >= fade_duration_ms:
			slow_mo_fade_out = false
			slow_mo_enabled = false
			time_scale = END_SPEED
		Engine.time_scale = time_scale

func start(start_strength = 0.9):
	start_speed = 1 - start_strength
	Engine.time_scale = start_speed
	slow_mo_enabled = true

func start_temporary(start_strength = 0.9, duration = 1, fade_duration = 0.4):
	start_speed = 1 - start_strength
	Engine.time_scale = start_speed
	slow_mo_enabled = true
	
	temporary_start_enabled = true
	temporary_start_duration_ms = duration * 1000
	temporary_start_time = OS.get_ticks_msec()
	fade_duration_ms = fade_duration * 1000

func stop(fade_duration = 0.4):
	stopped_time = OS.get_ticks_msec()
	fade_duration_ms = fade_duration * 1000
	slow_mo_fade_out = true

func circ_ease_in(t, b, c, d):
	t /= d
	return -c * (sqrt(1 - t * t) - 1 ) + b
