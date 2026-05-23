extends Control

signal StartGame

var highScores : Array = []
@export var MaxLeaderBoardEntries : int = 10

const SAVEFILE : String = "user://highscores.save"

func _ready() -> void:
	loadLeaderBoard()
	updateLeaderboard()
	

func _on_game_manager_score_updated(score: int) -> void:
	$RichTextLabel.text = "Score: " + str(score)
	pass # Replace with function body.

func updateLeaderboard():
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


func _on_game_manager_game_over(score: int) -> void:
	$GameOverContainer.show()
	$GameOverContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(score)
	
	$LeaderBoard.show()
	highScores.append(score)
	highScores.sort()
	highScores.reverse()
	
	if highScores.size() > MaxLeaderBoardEntries: 
		highScores.resize(MaxLeaderBoardEntries)
		
	updateLeaderboard()
	saveLeaderBoard()
	pass 

func loadLeaderBoard():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if file:
		highScores = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		print("Error: could not read high score")

func saveLeaderBoard():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(highScores))
		file.close()
	else:
		print("Error: could not save high score")

func _on_button_button_down() -> void:
	StartGame.emit()
	$GameOverContainer.hide()
	$StartGameContainer.hide()
	$LeaderBoard.hide()
	pass # Replace with function body.
