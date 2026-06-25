@abstract
@icon("uid://clnmc1wtig47a")
class_name CombatArea3D
extends Area3D
## Abstract base class for combat-related Area3D nodes.
## 
## Provides team management functionality that all combat components inherit from.

## Emitted when the [member team] is changed.
signal team_changed(new_team: Team)

enum Team {
	Neutral, ## Entities that are neutral towards the player.
	Friendly, ## Player and the player-friendly entities.
	Enemy, ## Entities that are hostile towards the player.
	}

## The team this [CombatArea3D] belongs to.
@export var team: Team:
	set(value):
		if value == team:
			return
		team = value
		team_changed.emit(team)
