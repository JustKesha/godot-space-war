@icon("uid://bgaokgo4ivbwr")
class_name SelfDestructEntityTrait
extends EntityTrait


func execute(entity: Entity3D):
	if entity:
		entity.destroy()
