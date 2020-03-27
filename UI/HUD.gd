extends CanvasLayer

var score = 0

func update_score(value):
	$MarginContainer/Score.text = str(value)

func _on_Enemy_dead():
	score += 10
	
	update_score(score)

func _on_Endless_Level_manually_restarting():
	$Tween.interpolate_property(self, "score", score, 0, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	update_score(round(score))
