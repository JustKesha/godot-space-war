@abstract
@icon("uid://bycsblt2nt2xh")
class_name EntityTrait
extends Resource


enum Trigger {
	SPAWNED = 0,
	TEAM_CHANGED = 1,
	DAMAGE_TAKEN = 2,
	DAMAGE_DEALT = 3,
	DESTROYED = 4,
	}

@export var triggers: Array[Trigger]


func execute(_entity: Entity3D):
	pass
