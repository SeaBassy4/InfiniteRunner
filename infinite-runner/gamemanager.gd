extends Node3D

signal ScoreUpdated(score : int)
signal GameOver(score : int)
signal StartGame()
var score : int = 0

@export var ObstacleScene : Array[PackedScene] = []
@export var PowerupsScene : Array[PackedScene] = []
@export var MinSpawnTime : float = 1.0
@export var MaxSpawnTime : float = 2.0
@export var SpawnDistance : float = -20.0
@export var PickupableSpawnChance : float = .3


var lanePositions = [-2.0, 0.0, 2.0]
var speedMultiplyer : float = 1.0

func _on_spawn_timer_timeout() -> void:
	
	var randValue = randf()
	if randValue < PickupableSpawnChance:
		var obstacleScene = PowerupsScene[randi() % PowerupsScene.size()]
		var currentOB = obstacleScene.instantiate()
		if currentOB.CurrentPickupType == Pickupable.PickupType.COIN:
			spawnCoinFormation(obstacleScene)
			currentOB.queue_free()
		#var spawnedLane = randi() % 3
		#currentOB.position = Vector3(lanePositions[spawnedLane], 0, SpawnDistance)
		#$ObstacleContainer.add_child(currentOB)
	else:
		var obstacleScene = ObstacleScene[randi() % ObstacleScene.size()]
		var currentOB = obstacleScene.instantiate()
		
		if currentOB.CurrentObstacleType == Obstacle.ObstacleType.LOW or currentOB.CurrentObstacleType == Obstacle.ObstacleType.HIGH: 
			var obstacle = obstacleScene.instantiate()
			obstacle.position = Vector3(0, 0, SpawnDistance)
			$ObstacleContainer.add_child(obstacle)
			obstacle.Speed = obstacle.Speed * speedMultiplyer
			currentOB.queue_free()
		else:
			var openLane = randi() % 3
			for i in range(3):
				if i != openLane:
					var obstacle = obstacleScene.instantiate()
					obstacle.position = Vector3(lanePositions[i], 0, SpawnDistance)
					$ObstacleContainer.add_child(obstacle)
					obstacle.Speed = obstacle.Speed * speedMultiplyer
			currentOB.queue_free()
	pass 


func _on_score_timer_timeout() -> void:
	score += 1 + (1 * speedMultiplyer)
	speedMultiplyer += 0.01
	ScoreUpdated.emit(score)
	pass 


func _on_player_add_score(score: int) -> void:
	self.score += score + (score * speedMultiplyer)
	speedMultiplyer += 0.01
	ScoreUpdated.emit(self.score)
	pass 

func spawnCoinFormation(coinScene : PackedScene): 
	var lane = randi() % 3
	var formationType = randi() % 3
	match formationType:
		0:
			var coin = coinScene.instantiate()
			coin.position = Vector3(lanePositions[lane], 0, SpawnDistance)
			$ObstacleContainer.add_child(coin)
			coin.Speed = coin.Speed * speedMultiplyer
		1:
			for i in range(randi() % 3):
				var coin = coinScene.instantiate()
				coin.position = Vector3(lanePositions[lane], 0, SpawnDistance + (i *2))
				$ObstacleContainer.add_child(coin)
				coin.Speed = coin.Speed * speedMultiplyer
		2: 
			var direction = 1 if randf() > 0.5 else -1
			if lane < 0:
				lane += 3
			for i in range(3):
				var index = (lane + (i * direction)) % 3
				var coin = coinScene.instantiate()
				coin.position = Vector3(lanePositions[index], 0, SpawnDistance + (i *2))
				$ObstacleContainer.add_child(coin)
				coin.Speed = coin.Speed * speedMultiplyer


func _on_death_plane_area_entered(area: Area3D) -> void:
	$SpawnTimer.stop()
	$ScoreTimer.stop()
	GameOver.emit(score)
	pass

func _on_ui_manager_start_game() -> void:
	score = 0
	speedMultiplyer = 1.0
	$ScoreTimer.start()
	$SpawnTimer.start()
	ScoreUpdated.emit(score)
	StartGame.emit()
	pass
