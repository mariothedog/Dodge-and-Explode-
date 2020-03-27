extends CanvasLayer

var score = 0

func _on_Enemy_dead():
	score += 10
	
	$MarginContainer/Score.text = str(score)
