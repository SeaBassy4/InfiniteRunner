extends Node3D

signal ScoreUpdated(score : int)
var score : int = 0

@export var ObstacleScene : Array[PackedScene] = []
@export var PowerupsScene : Array[PackedScene] = []
@export var MinSpawnTime : float = 1.0
@export var MaxSpawnTime : float = 2.0
@export var SpawnDistance : float = -20.0
@export var PickupableSpawnChance : float = .3

var lanePositions = [-2.0, 0.0, 2.0]

func _on_spawn_timer_timeout() -> void:
	
	var randValue = randf()
	if randValue < PickupableSpawnChance:
		var obstacleScene = PowerupsScene[randi() % PowerupsScene.size()]
		var currentOB = obstacleScene.instantiate()
		var spawnedLane = randi() % 3
		currentOB.position = Vector3(lanePositions[spawnedLane], 0, SpawnDistance)
		$ObstacleContainer.add_child(currentOB)
	else:
		var obstacleScene = ObstacleScene[randi() % ObstacleScene.size()]
		var currentOB = obstacleScene.instantiate()
		
		if currentOB.CurrentObstacleType == Obstacle.ObstacleType.LOW or currentOB.CurrentObstacleType == Obstacle.ObstacleType.HIGH: 
			var obstacle = obstacleScene.instantiate()
			obstacle.position = Vector3(0, 0, SpawnDistance)
			$ObstacleContainer.add_child(obstacle)
			currentOB.queue_free()
		else:
			var openLane = randi() % 3
			for i in range(3):
				if i != openLane:
					var obstacle = obstacleScene.instantiate()
					obstacle.position = Vector3(lanePositions[i], 0, SpawnDistance)
					$ObstacleContainer.add_child(obstacle)
			currentOB.queue_free()
	pass 


func _on_score_timer_timeout() -> void:
	score += 1
	ScoreUpdated.emit(score)
	pass 


func _on_player_add_score(score: int) -> void:
	self.score += score
	ScoreUpdated.emit(self.score)
	pass 
