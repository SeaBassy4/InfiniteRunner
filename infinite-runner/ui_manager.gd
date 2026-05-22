extends Control



func _on_game_manager_score_updated(score: int) -> void:
	$RichTextLabel.text = "Score: " + str(score)
	pass # Replace with function body.
