@abstract
@icon("uid://clnmc1wtig47a")
class_name CombatArea3D
extends Area3D


signal team_changed(new_team: Team)

enum Team {
	Neutral,
	Friendly,
	Enemy,
	}

@export var team: Team:
	set(value):
		if value == team:
			return
		team = value
		team_changed.emit(team)
