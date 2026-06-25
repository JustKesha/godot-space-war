@icon("uid://5geoeo7q8wye")
class_name HurtComponent3D
extends CombatArea3D


signal damage_taken(amount: float, source: HitComponent3D)

@export var team: Team
## Any incoming damage lower or equal to this threshold will be ignored.
@export var damage_detection_threshold: float


func take_damage(amount: float, source: HitComponent3D):
	if amount < damage_detection_threshold:
		return
	
	damage_taken.emit(amount, source)
