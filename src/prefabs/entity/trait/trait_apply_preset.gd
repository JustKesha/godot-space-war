@icon("uid://s7xtqhssplqo")
class_name ApplyPresetEntityTrait
extends EntityTrait


@export var preset: EntityPreset3D


func execute(entity: Entity3D):
	if entity:
		entity.apply_preset(preset)
