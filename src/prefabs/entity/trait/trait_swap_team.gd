@icon("uid://dyxypaetfvkmi")
class_name SwapTeamEntityTrait
extends EntityTrait


@export var new_team: CombatArea3D.Team


func execute(entity: Entity3D):
	if entity:
		entity.team = new_team
