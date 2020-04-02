extends CanvasLayer

var score = 0

func update_score(value):
	$MarginContainer/Score.text = str(value)

func _on_Enemy_dead(_cause):
	var combo = get_parent().get_node("Player").combo
	score += 10 + (combo - 1) * 5
	
	update_score(score)

func _on_Endless_Level_manually_restarting():
	$Tween.interpolate_property(self, "score", score, 0, 0.5)
	$Tween.start()

func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	update_score(round(score))
