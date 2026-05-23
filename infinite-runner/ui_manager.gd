extends Control

signal StartGame

var highScores : Array = []
@export var MaxLeaderBoardEntries : int = 10

func _on_game_manager_score_updated(score: int) -> void:
	$RichTextLabel.text = "Score: " + str(score)
	pass # Replace with function body.


func _on_game_manager_game_over(score: int) -> void:
	$GameOverContainer.show()
	$GameOverContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(score)
	
	$LeaderBoard.show()
	highScores.append(score)
	highScores.sort()
	highScores.reverse()
	
	if highScores.size() > MaxLeaderBoardEntries: 
		highScores.resize(MaxLeaderBoardEntries)
		
	for child in $LeaderBoard/VBoxContainer.get_children():
		if child.name != "Label":
			child.queue_free()
	
	for i in range(highScores.size()):
		var entry = RichTextLabel.new()
		entry.text = "%d. %d" % [i + 1, highScores[i]]
		$LeaderBoard/VBoxContainer.add_child(entry)
		entry.bbcode_enabled = true
		entry.custom_minimum_size = Vector2(0,25)
		if i == 0:
			entry.text = "[b]%d. %d" % [i + 1, highScores[i]]
	pass 


func _on_button_button_down() -> void:
	StartGame.emit()
	$GameOverContainer.hide()
	$StartGameContainer.hide()
	$LeaderBoard.hide()
	pass # Replace with function body.
