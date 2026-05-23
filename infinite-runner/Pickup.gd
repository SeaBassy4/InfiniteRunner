extends Area3D
class_name Pickupable

enum PickupType {COIN, POWERUP, BOOST}
@export var CurrentPickupType = PickupType.COIN
@export var Speed : float = 10.0
@export var Score = 1

func _process(delta: float) -> void:
	position.z += Speed * delta


func _on_area_entered(area: Area3D) -> void:
	queue_free()
	pass # Replace with function body.
