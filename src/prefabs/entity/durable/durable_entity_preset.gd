@icon("uid://dsxh0g7d8lc8w")
class_name DurableEntityPreset3D
extends EntityPreset3D


@export var account_for_damage_taken: bool = true:
	set(value):
		if account_for_damage_taken == value:
			return
		account_for_damage_taken = value
		_on_changed()
@export var account_for_damage_dealt: bool = true:
	set(value):
		if account_for_damage_dealt == value:
			return
		account_for_damage_dealt = value
		_on_changed()
@export var self_damage_on_damage_taken: float:
	set(value):
		if self_damage_on_damage_taken == value:
			return
		self_damage_on_damage_taken = value
		_on_changed()
@export var self_damage_on_damage_dealt: float:
	set(value):
		if self_damage_on_damage_dealt == value:
			return
		self_damage_on_damage_dealt = value
		_on_changed()
@export_group("Health", "health")
@export_subgroup("Start", "health_start")
@export var health_start_ratio: float = 1.0:
	set(value):
		if health_start_ratio == value:
			return
		health_start_ratio = value
		_on_changed()
@export var health_start_bonus: float = 0.0:
	set(value):
		if health_start_bonus == value:
			return
		health_start_bonus = value
		_on_changed()
@export_subgroup("Limits", "health_value")
@export var health_value_min: float = 0.0:
	set(value):
		if health_value_min == value:
			return
		health_value_min = value
		_on_changed()
@export var health_value_max: float = 1.0:
	set(value):
		if health_value_max == value:
			return
		health_value_max = value
		_on_changed()
@export_subgroup("Increase", "health_increase")
@export var health_increase_ratio: float = 1.0:
	set(value):
		if health_increase_ratio == value:
			return
		health_increase_ratio = value
		_on_changed()
@export var health_increase_threshold: float = 0.0:
	set(value):
		if health_increase_threshold == value:
			return
		health_increase_threshold = value
		_on_changed()
@export_subgroup("Decrease", "health_decrease")
@export var health_decrease_ratio: float = 1.0:
	set(value):
		if health_decrease_ratio == value:
			return
		health_decrease_ratio = value
		_on_changed()
@export var health_decrease_threshold: float = 0.0:
	set(value):
		if health_decrease_threshold == value:
			return
		health_decrease_threshold = value
		_on_changed()


func apply(entity: Entity3D) -> bool:
	var durable_entity := entity as DurableEntity3D
	
	if not durable_entity:
		push_error("Could not apply preset. Recieved entity is not durable.")
		return false
	
	durable_entity.account_for_damage_taken = account_for_damage_taken
	durable_entity.account_for_damage_dealt = account_for_damage_dealt
	durable_entity.self_damage_on_damage_taken = self_damage_on_damage_taken
	durable_entity.self_damage_on_damage_dealt = self_damage_on_damage_dealt
	
	durable_entity.health.start_ratio = health_start_ratio
	durable_entity.health.start_bonus = health_start_bonus
	durable_entity.health.value_min = health_value_min
	durable_entity.health.value_max = health_value_max
	durable_entity.health.increase_ratio = health_increase_ratio
	durable_entity.health.increase_threshold = health_increase_threshold
	durable_entity.health.decrease_ratio = health_decrease_ratio
	durable_entity.health.decrease_threshold = health_decrease_threshold
	durable_entity.health.reset()
	
	return super(entity)
