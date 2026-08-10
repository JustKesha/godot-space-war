@icon("uid://c5qmnd3ynrlhn")
class_name Combatant3D
extends Obstacle3D


@onready var gun: ShootComponent3D = %Gun


func _update_team():
	if gun: gun.team = team
	super()


func destroy():
	if not Game.current_level:
		return super()
	
	Game.current_level.combatants.kill(self)
	destroyed.emit()
