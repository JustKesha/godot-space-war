@icon("uid://ca7ytq15dicmj")
class_name ScoreComponent
extends Node


signal score_changed(new_value: float)
signal score_increased(by: float)
signal score_decreased(by: float)

enum SourceType {
	DESTOYED_COMBATANT = 0,
	DESTOYED_OBSTACLE = 1,
	DESTOYED_PROJECTILE = 2,
	}

@export var parent: Entity3D
@export var value: float:
	set(new_value):
		if new_value == value:
			return
		
		var old_value := value
		
		value = new_value
		
		score_changed.emit(new_value)
		if new_value > old_value:
			score_increased.emit(new_value - old_value)
		elif new_value < old_value:
			score_decreased.emit(old_value - new_value)
@export var multiplier: float = 1.0
@export var multipliers: Dictionary[SourceType, float] = {
	SourceType.DESTOYED_COMBATANT: 1.0,
	SourceType.DESTOYED_OBSTACLE: 0.5,
	SourceType.DESTOYED_PROJECTILE: 0.0,
	}


func _ready():
	if not parent:
		parent = get_parent() as Entity3D
	if not parent:
		push_warning("Parent entity was not selected or found.
			The component wont be able to function properly.")
	Events.entity_destroyed.connect(_on_entity_destoyed)


func _on_entity_destoyed(destroyed_entity: Entity3D, killer_signature: int):
	if( not is_instance_valid(parent) or
		not Utils.match_signatures(parent.get_signature(), killer_signature) ):
		return
	
	value += calc_entity_destroyed_score(destroyed_entity)


func calc_entity_destroyed_score(entity: Entity3D) -> float:
	if entity is Projectile3D:
		return multiplier * multipliers.get(SourceType.DESTOYED_PROJECTILE, 1.0)
	
	if entity is Obstacle3D:
		var obstacle := entity as Obstacle3D
		return obstacle.difficulty * multiplier * multipliers.get(SourceType.DESTOYED_OBSTACLE, 1.0)
	
	if entity is Combatant3D:
		var combatant := entity as Combatant3D
		return combatant.difficulty * multiplier * multipliers.get(SourceType.DESTOYED_COMBATANT, 1.0)
	
	return 0.0
