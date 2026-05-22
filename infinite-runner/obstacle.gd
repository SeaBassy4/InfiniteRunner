extends StaticBody3D
class_name Obstacle

enum ObstacleType {STANDARD, LOW, HIGH}

@export var CurrentObstacleType : ObstacleType = ObstacleType.STANDARD
@export var Speed : float = 10.0

func _process(delta: float) -> void:
	position.z += Speed * delta
