@icon("uid://5geoeo7q8wye")
class_name HurtComponent3D
extends CombatArea3D
## Component that can receive damage from [HitComponent3D] nodes.


## Emitted when the [method take_damage] is executed successfully.
signal damage_taken(amount: float, source: HitComponent3D)

## Any incoming damage lower or equal to this threshold will be ignored.
@export var damage_detection_threshold: float


## Emits [signal damage_taken] if the given damage is accepted.
func take_damage(amount: float, source: HitComponent3D):
	if amount < damage_detection_threshold:
		return
	
	damage_taken.emit(amount, source)
