extends Node2D

func _ready():
	visible = false

func display(combo):
	if combo > 1:
		$Label.text = "x%s" % combo
		visible = true
		$AnimationPlayer.play("Display")
